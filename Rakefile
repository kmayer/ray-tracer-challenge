require "bundler/gem_tasks"
require "rspec/core/rake_task"

task :default => [:spec, :test]

RSpec::Core::RakeTask.new(:spec)

task :test do
  sh "cucumber --no-snippets"
end

task :watch do
  sh "filewatcher --list 'features/**/* lib/**/*.rb' 'clear; cucumber --tags @focus'"
end
