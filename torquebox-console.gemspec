# -*- encoding: utf-8 -*-
require './lib/torquebox/console/version'

Gem::Specification.new do |s|
  s.name = %q{torquebox-console}
  s.version = TorqueBox::Console::VERSION
  s.date = Time.now.strftime('%Y-%m-%d')
  s.authors = ["Lance Ball"]
  
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.description = %q{TorqueBox Console allows you to peer into the TorqueBox guts using a repl command line. You can view information about the components and applications you have running.}
  s.email = %q{lball@redhat.com}
  s.executables = ["tbconsole"]
  s.extra_rdoc_files = [
                        "README.md",
                        "LICENSE",
                        "TODO"
                       ]
  s.files = Dir[
                "LICENSE",
                "dependencies.rb",
                "config/**/*",
                "lib/**/*",
                "views/**/*",
                "stomplets/**/*",
                "public/**/*",
                "bin/**/*",
                "vendor/bundle/**/*",
                "config.ru",
                "console.rb"
               ]

  s.homepage = %q{http://github.com/torquebox/torquebox-console}
  s.licenses = ["AL"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.5.1}
  s.summary = %q{TorqueBox Console - A REPL commandline and information viewer for TorqueBox}

end
