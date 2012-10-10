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

module TorqueBox
  module Console
    class Server

      attr_accessor :queue

      def initialize( queue )
        @queue = queue
        yield self if block_given?
      end

      def run
        Thread.new do 
          Pry.config.pager  = false
          Pry.config.color  = false
          Pry.config.prompt = proc { "TorqueBox> " }
          Pry.start binding, :input => self, :output => self
        end
      end

      # Pry channels
      def readline( prompt )
        # here we need to wait on input from the client
        #message = TorqueBox::Stomp::Message.new( prompt, {'prompt' => true} )
        queue.publish_and_receive( prompt )
      end

      def puts( output = "" )
        queue.publish output.to_s
      end

    end # TorqueBox::Console::Server
  end # TorqueBox::Console
end # TorqueBox




