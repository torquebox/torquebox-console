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

require 'pry'
require 'torquebox-stomp'
require 'torquebox-cache'
require 'torquebox-messaging'

module TorqueBox
  module Console
    class Server

      attr_accessor :input_queue, :output_queue, :console_id

      def initialize
        @cache = TorqueBox::Infinispan::Cache.new(:name=>"torquebox-console")
        @console_id = @cache.increment( "console" )

        input_name = "/queues/torquebox-console/#{console_id}-input"
        output_name = "/queues/torquebox-console/#{console_id}-output"

        @input_queue = TorqueBox::Messaging::Queue.start( input_name, :durable => false )
        @output_queue = TorqueBox::Messaging::Queue.start( output_name, :durable => false )
      end

      def run
        Thread.new do 
          Pry.config.pager  = false
          Pry.config.color  = false
          Pry.config.prompt = proc { "TorqueBox> " }
          Pry.start binding, :input => self, :output => self
        end
      end

      # Pry input channel
      def readline( prompt )
        # First send the repl prompt to the client
        output_queue.publish prompt
        # Then wait for input
        input_queue.receive
      end

      # Pry output channel
      def puts( output = "" )
        output_queue.publish output.to_s
      end

      # Pry (undocumented?) requires this
      def tty?
        false
      end

    end # TorqueBox::Console::Server
  end # TorqueBox::Console
end # TorqueBox


