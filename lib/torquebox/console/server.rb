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

module TorqueBox
  module Console
    class Server

      attr_accessor :subscriber

      def initialize( subscriber )
        @subscriber = subscriber
      end

      def run
        Pry.config.pager = false
        Thread.new do 
          Pry.start binding, :input => self, :output => self, :prompt_name => "TorqueBox"
        end
      end

      # Pry channels
      def readline( prompt )
        subscriber.send prompt
      end

      def puts( output = "" )
        subscriber.send output
      end

    end # TorqueBox::Console::Server
  end # TorqueBox::Console
end # TorqueBox




