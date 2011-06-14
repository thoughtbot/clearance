# encoding: utf-8

require 'rubygems'
require 'bundler/setup'
require 'rake'
require 'rake/gempackagetask'
require 'cucumber/rake/task'
require 'diesel/tasks'
require 'rspec/core/rake_task'
require 'appraisal'

desc "Default: run the specs and cucumber features"
task :default => [:all]

desc 'Test the plugin under all supported Rails versions.'
task :all => ["appraisal:install"] do |t|
  exec('rake appraisal spec cucumber')
end

RSpec::Core::RakeTask.new do |t|
  t.pattern = 'spec/**/*_spec.rb'
end

Cucumber::Rake::Task.new(:cucumber) do |t|
  t.fork = true
  t.cucumber_opts = ['--format', (ENV['CUCUMBER_FORMAT'] || 'progress')]
end

