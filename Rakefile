# encoding: utf-8
require 'rubygems'
require 'bundler/setup'
require 'bundler/gem_tasks'

require 'rake'
require 'cucumber/rake/task'
require 'rspec/core/rake_task'
require 'clearance/testing/application'

desc 'Default'
task :default => [:all]

desc 'Run the specs and cucumber featrues'
task :all => [:spec, :cucumber]

Clearance::Testing::Application.load_tasks

Cucumber::Rake::Task.new(:cucumber) do |t|
  t.fork = false
  t.cucumber_opts = ['--format', (ENV['CUCUMBER_FORMAT'] || 'progress')]
end

RSpec::Core::RakeTask.new(:spec)
