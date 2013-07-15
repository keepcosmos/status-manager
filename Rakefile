require 'bundler/gem_tasks'
require 'rake'
require 'rake/testtask'

desc "Default: run unit tests."
task :default => :test

desc "Test Status Manager"
Rake::TestTask.new(:test) do |t|
	t.libs << %w[lib test]
	t.pattern = 'test/**/*_test.rb'
	t.verbose = true
end