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
    module Builtin
      extend TorqueBox::Injectors
      class << self

      # Simple placeholder methods - the stomplet is responsible
      # for actually switching runtimes
      def switch_application(app)
        switch_runtime(app, 'web')
      end
      def switch_runtime(app, runtime)
        [app, runtime]
      end

      def list_applications
        list_runtimes.map { |runtimes| runtimes.first }.uniq
      end

      def list_runtimes
        service_registry = fetch("service-registry")
        service_registry.service_names.to_a.map { |x| parse_pool_name(x) }.
          reject(&:nil?).map { |app, runtime, svc_name| [app, runtime] }.sort
      end

      def parse_pool_name(service_name)
        [$1, $3, service_name] if service_name.canonical_name =~
          /"(.*)(-knob\.yml|\.knob)"\.torquebox\.core\.runtime\.pool\.([^.]+)$/
      end

      def create_block
        Proc.new {}
      end
      end
    end
  end
end
