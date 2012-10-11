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

require 'torquebox'

module TorqueBox
  module Console
    module Builtin
      extend TorqueBox::Injectors
      class << self
      def service_registry
        @@service_registry ||= inject("service-registry")
      end

      def list_runtimes
        get_runtimes.each do |runtime| 
          puts "Application: #{runtime[0]}"
          puts "Pool: #{runtime[1]}"
        end
      end

      def get_runtimes
        service_registry.service_names.to_a.map { |x| parse_pool_name(x) }.reject(&:nil?)
      end

      def parse_pool_name(service_name)
        [$1, $3, service_name] if service_name.canonical_name =~
          /"(.*)(-knob\.yml|\.knob)"\.torquebox\.core\.runtime\.pool\.([^.]+)$/
      end
      end
    end
  end
end
