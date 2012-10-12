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

module TorqueBox
  module Console
    class Client
      HEADERS = { "accept-version" => "1.1", "host" => "localhost" }              
      HOSTS   = [{:host => "localhost", :port => 8675}]

      attr_accessor :client

      def initialize
        @client = Stomp::Client.new( { :hosts => HOSTS, :connect_headers => HEADERS } )
      end

      def self.connect
        Client.new.run
      end

      def run
        client.subscribe("/stomplet/console") do |msg| 
          msg.headers['prompt'] ? print(msg.body) : puts(msg.body)
        end
        while((input = gets).chop != "exit") do
          client.publish("/stomplet/console", input)
        end
      end

    end
  end
end
