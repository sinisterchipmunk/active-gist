require "bundler/gem_tasks"
require 'active_gist/version'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new

require 'rdoc/task'
RDoc::Task.new do |t|
  t.rdoc_dir = 'doc'
  t.title    = "ActiveGist #{ActiveGist::VERSION} Documentation"
  t.options << '--line-numbers'
  t.rdoc_files.include('README.rdoc', 'CHANGELOG', 'LICENSE', 'lib/**/*.rb')
end

task :default => :spec
