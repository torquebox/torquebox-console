# Copyright 2012 Lance Ball
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require File.join(File.dirname(__FILE__), '..', 'dependencies')
require 'torquebox-cache'
require 'torquebox-messaging'
require 'torquebox-stomp'
require 'torquebox-console'

class TorqueBoxConsole < TorqueBox::Stomp::JmsStomplet
  include TorqueBox::Injectors

  def configure( options )
    super
    @servers = {}
    @server_runtimes = {}
    @cache = TorqueBox::Infinispan::Cache.new(:name=>"torquebox-console")
  end

  def on_message( message, session )
    console_id = session["console_id"]
    input = message.content_as_string
    servers = @servers[console_id]
    if servers
      server = servers.last
      input_queue = TorqueBox::Messaging::Queue.new( server.input_queue.name )
      output_queue = TorqueBox::Messaging::Queue.new( output_name( console_id ) )
      # Intercept the switch runtime commands
      if input =~ /^\s*(switch_application|switch_runtime).+$/
        begin
          app, runtime = server.evaluate( input )
        rescue Exception => e
          send_to( output_queue, e.message )
          send_to( input_queue, "" )
          return
        end
        success = switch_runtime( app, runtime, console_id )
        if success
          send_to( output_queue, "Switched to #{runtime} runtime of #{app} application" )
        else
          send_to( output_queue, "Invalid application or runtime requested" )
          send_to( input_queue, "" )
        end
      else
        send_to( input_queue, input )
      end
    else
      logger.error("No server found for console #{console_id}")
    end
  end

  def on_subscribe( subscriber )
    console_id = @cache.increment( "console" )
    output_queue = TorqueBox::Messaging::Queue.start( output_name( console_id ), :durable => false )

    # Make sure we can find the console using session
    subscriber.session["console_id"] = console_id
    logger.info "Running TorqueBox console #{console_id}."

    # Subscribe our stomplet connection to the server's queue
    subscribe_to( subscriber, output_queue )

    # start the console against the current app
    switch_runtime( ENV['TORQUEBOX_APP_NAME'], 'web', console_id )
  end

  def on_unsubscribe( subscriber )
    session = subscriber.session
    logger.info "Closing TorqueBox console #{session["console_id"]}"
    @servers.delete( session["console_id"] )
  end

  def destroy
    @servers.each_key do |k|
      logger.info "Closing TorqueBox console #{k}"
      @servers.delete(k)
    end
  end

  def output_name(console_id)
    "/queues/torquebox-console/#{console_id}-output"
  end

  def switch_runtime(app, runtime, console_id)
    runtime ||= 'web'
    @server_runtimes[console_id] ||= {}
    @server_runtimes[console_id][app] ||= {}
    existing_server = @server_runtimes[console_id][app][runtime]
    if existing_server
      # shuffle the desired runtime to the current one
      @servers[console_id] << @servers[console_id].delete( existing_server )
      input_queue = TorqueBox::Messaging::Queue.new( existing_server.input_queue.name )
      send_to( input_queue, "" )
    else
      deps = File.join(File.dirname(__FILE__), '..', 'dependencies') 
      pool = lookup_runtime( app, runtime )
      return false if pool.nil?
      pool.evaluate("require '#{deps}'")
      pool.evaluate("require 'torquebox/console/server'")
      pool.evaluate("require 'torquebox/console/builtin'")

      server_id = Time.now.to_f.to_s
      input_name = "/queues/torquebox-console/#{console_id}-#{server_id}-input"
      output_name = output_name( console_id )

      server = pool.evaluate( """
        input_queue = TorqueBox::Messaging::Queue.start( '#{input_name}', :durable => false )
        output_queue = TorqueBox::Messaging::Queue.new( '#{output_name}' )
        server = TorqueBox::Console::Server.new( #{console_id}, input_queue, output_queue, '#{app}', '#{runtime}' )
        server.run( TorqueBox::Console::Builtin )
        server
      """ )
      @server_runtimes[console_id][app][runtime] = server
      @servers[console_id] ||= []
      @servers[console_id] << server
    end
    true
  end

  def web_runtime(app)
    lookup_runtime(app, 'web')
  end

  def lookup_runtime(app, name)
    service_registry = fetch('service-registry')
    service_name = nil

    if app
      _, _, service_name = list_runtimes.detect { |v| v[0] == app && v[1] == name }
    else
      unit = fetch('deployment-unit')
      service_name = org.torquebox.core.as.CoreServices.runtimePoolName(unit, name)
    end

    return nil unless service_name
    service_controller = service_registry.get_service(service_name)
    return nil unless service_controller
    pool = service_controller.service.value
    pool
  end

  def list_runtimes
    service_registry = fetch("service-registry")
    service_registry.service_names.to_a.map { |x| parse_pool_name(x) }.reject(&:nil?)
  end

  def parse_pool_name(service_name)
    [$1, $3, service_name] if service_name.canonical_name =~
      /"(.*)(-knob\.yml|\.knob)"\.torquebox\.core\.runtime\.pool\.([^.]+)$/
  end

  def logger
    @logger ||= TorqueBox::Logger.new( self )
  end

end

