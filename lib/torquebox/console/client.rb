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

require 'stomp'
require 'readline'

module TorqueBox
  module Console
    class Client
      HEADERS = { "accept-version" => "1.1", "host" => "localhost" }
      HOSTS   = [{:host => "localhost", :port => 8675}]
      PARAMS  = { :connect_headers => HEADERS, :hosts => HOSTS, :max_reconnect_attempts => -1 }

      attr_accessor :client

      def initialize
        @client = Stomp::Client.new( PARAMS )
        @stty_save = `stty -g`.chomp
      rescue Stomp::Error::MaxReconnectAttempts
        puts "Can't connect to TorqueBox. Are you sure the server is running?"
      end

      def self.connect
        Client.new.run
      end

      def run
        if client
          client.subscribe("/stomplet/console") do |msg| 
            !msg.headers['prompt'] && puts(msg.body)
          end
          # Since our messaging is async, sleep
          # before displaying the prompt
          sleep 0.3
          while(input = Readline.readline( "TorqueBox> ", true ))
            client.publish("/stomplet/console", input)
            sleep 0.3 # again with the async
          end
          client.unsubscribe('/stomplet/console')
        end
      end
    end
  end
end
