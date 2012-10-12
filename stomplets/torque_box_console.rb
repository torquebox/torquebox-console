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
require 'torquebox-console'

class TorqueBoxConsole < TorqueBox::Stomp::JmsStomplet

  def configure( options )
    super
    @servers = {}
  end

  def on_message( message, session )
    server = @servers[session["console_id"]]
    if server
      send_to( server.input_queue, message.content_as_string )
    else
      logger.error("No console found for the server #{server}") 
    end
  end

  def on_subscribe( subscriber )
    # Create a new server that sends/receives on the queue
    puts subscriber.inspect
    server = TorqueBox::Console::Server.new

    # Keep a reference to it around for a while
    console_id = server.console_id
    @servers[console_id] = server

    # Make sure we can find the server using session
    subscriber.session["console_id"] = console_id
    logger.info "Running TorqueBox console #{console_id}."

    # Subscribe our stomplet connection to the server's queue 
    subscribe_to( subscriber, server.output_queue )
    server.run( TorqueBox::Console::Builtin )
  end
 
  def on_unsubscribe( subscriber )
    session = subscriber.session
    logger.info "Closing TorqueBox console #{session["console_id"]}"
    @servers.delete( session["console_id"] )
  end

  def logger
    @logger ||= TorqueBox::Logger.new( self )
  end

end

