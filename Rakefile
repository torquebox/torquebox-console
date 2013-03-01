# encoding: utf-8

require './lib/torquebox/console/version'

GEMFILE = "torquebox-console-#{TorqueBox::Console::VERSION}.gem" 

task :default => :build

desc "Build the gem"
task :build => [ :resolve_deps ] do
  p "Building #{GEMFILE}"
  system "gem build --force torquebox-console.gemspec"
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

task :bundle do
  p "Bundling runtime dependencies in vendor/bundle"
  system "bundle package"
  system "bundle install --local --without development --deployment"
end

task :resolve_deps => [ :bundle ] do
  lib_dirs = Dir["./vendor/bundle/jruby/1.9/**/*"].select { |f| File.directory?(f) && f.end_with?("/lib") ? true : nil }

  File.open("dependencies.rb", File::CREAT|File::TRUNC|File::RDWR, 0644) do |f|
    lib_dirs.each do |dir|
        p "Adding dependency on #{dir}"
        f.write("$:.unshift File.join(File.dirname(__FILE__), '#{dir}')\n")
    end
  end
end

