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

module TorqueBox
  module Console
    class Server

      attr_accessor :input_queue, :output_queue, :console_id, :application, :runtime

      def initialize(console_id, input_queue, output_queue, application, runtime)
        @console_id = console_id
        @input_queue = input_queue
        @output_queue = output_queue
        @application = application
        @runtime = runtime
      end

      def run( entry_point )
        Thread.new do
          Pry.config.pager  = false
          #Pry.config.color  = false
          Pry.config.prompt = proc { "TorqueBox (#{application}, #{runtime})> " }
          Pry.start entry_point, :input => self, :output => self
        end
      end

      # Pry input channel
      def readline( prompt )
        # First send the repl prompt to the client
        output_queue.publish prompt, {:properties => {'prompt' => 'true'}}
        # Then wait for input
        input_queue.receive
      end

      # Pry output channel
      def puts( output = "" )
        output_queue.publish output.to_s
      end

      def evaluate( code )
        binding = TorqueBox::Console::Builtin.create_block.binding
        eval( code, binding )
      end

      # Pry (undocumented?) requires this
      def tty?
        false
      end

    end # TorqueBox::Console::Server
  end # TorqueBox::Console
end # TorqueBox


