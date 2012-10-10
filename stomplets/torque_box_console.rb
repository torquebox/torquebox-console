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

require 'torquebox-stomp'
require 'torquebox-cache'
require 'torquebox-messaging'
require 'torquebox-console'

class TorqueBoxConsole < TorqueBox::Stomp::JmsStomplet

  def configure( options )
    super
    @cache = TorqueBox::Infinispan::Cache.new(:name=>"torquebox-console")
    @consoles = {}
  end

  def on_message( message, session )
    logger.info("Yo dawg!")
    console = @consoles[session["console"]]
    if console
      logger.info("Got a message from the console: #{message.inspect}")
    else
      logger.error("No console found for the current session #{session.inspect}") 
    end
  end

  def on_subscribe( subscriber )
    # Initialize and set session information
    session = subscriber.session
    console = @cache.increment( "console" )
    session["console"] = console
    logger.info "Begin: initializing service for torquebox-console #{console}"

    # Create a new queue for this connection
    queue = "/queues/torquebox-console/#{console}"
    queue = TorqueBox::Messaging::Queue.start( queue, :durable => false )

    # Subscribe our stomplet connection to the queue 
    subscribe_to( subscriber, queue )

    # Create a new server that sends/receives on the queue
    TorqueBox::Console::Server.new( queue ) do |server|
      @consoles[console] = server
      server.run
    end
    logger.info "End: torquebox-console service initialized for console #{console}"
  end
 
  def on_unsubscribe( subscriber )
    session = subscriber.session
    logger.info "Closing torquebox-console service for console #{session["console"]}"
    @consoles.delete( session["console"] )
  end

  def logger
    @logger ||= TorqueBox::Logger.new( self )
  end

end

