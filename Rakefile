task :default => :test

task :test do
  sh "cucumber --no-snippets"
end

task :watch do
  sh "filewatcher --list 'features/**/* lib/**/*.rb' 'clear; cucumber --tags @focus'"
end