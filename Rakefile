# encoding: utf-8

require 'rubygems'
require 'bundler/setup'
require 'rake'
require 'rubygems/package_task'
require 'cucumber/rake/task'
require 'diesel/tasks'
require 'rspec/core/rake_task'
require 'appraisal'

task :default do |t|
  if ENV['BUNDLE_GEMFILE'] =~ /gemfiles/
    exec 'rake spec cucumber'
  else
    Rake::Task['appraise'].execute
  end
end

task :appraise => ['appraisal:install'] do |t|
  exec 'rake appraisal spec cucumber'
end

RSpec::Core::RakeTask.new(:spec)

Cucumber::Rake::Task.new(:cucumber) do |t|
  t.fork = true
  t.cucumber_opts = ['--format', (ENV['CUCUMBER_FORMAT'] || 'progress')]
end

Bundler::GemHelper.install_tasks
