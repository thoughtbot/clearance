# encoding: utf-8

require 'rubygems'
require 'bundler/setup'
require 'rake'
require 'rake/gempackagetask'
require 'cucumber/rake/task'
require 'diesel/tasks'

Rake::TestTask.new do |task|
  task.libs << "lib"
  task.libs << "test"
  task.pattern = "test/*/*_test.rb"
  task.verbose = false
end

Cucumber::Rake::Task.new(:cucumber) do |t|
  t.fork = true
  t.cucumber_opts = ['--format', (ENV['CUCUMBER_FORMAT'] || 'progress')]
end

desc "Default: run the unit tests and cucumber features"
task :default => [:test, :cucumber]

