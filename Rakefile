require 'bundler/gem_tasks'
require 'rake'
require 'rake/testtask'
require 'rspec/core/rake_task'
Bundler::GemHelper.install_tasks

desc 'Default: run unit tests.'
task default: :spec

desc 'Run Status Manager RSpec'
RSpec::Core::RakeTask.new do |t|
  t.verbose = false
end
