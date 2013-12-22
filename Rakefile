require "bundler/gem_tasks"

require 'rake/testtask'

desc 'Test the rawk_log gem'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc "Run tests"
task :default => :test

