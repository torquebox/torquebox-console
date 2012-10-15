# encoding: utf-8

require 'bundler/setup'
require './lib/torquebox/console/version'

GEMFILE = "torquebox-console-#{TorqueBox::Console::VERSION}.gem" 

task :default => :build

desc "Build the gem"
task :build do
  system "gem build torquebox-console.gemspec"
end
 
desc "Release the gem to rubygems"
task :release => [ :build, :tag ] do
  system "gem push #{GEMFILE}"
end

desc "Build and install the gem locally"
task :install => :build do
  system "gem install -l -f #{GEMFILE}"
end

task :tag do
  system "git tag #{TorqueBox::Console::VERSION}"
end


