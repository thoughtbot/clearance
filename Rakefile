# encoding: utf-8
require "rubygems"
require "bundler/setup"
require "bundler/gem_tasks"

require "rake"
require "cucumber/rake/task"
require "rspec/core/rake_task"

namespace :dummy do
  require_relative "spec/dummy/application"
  Dummy::Application.load_tasks
end

desc "Default"
task default: [:spec, :cucumber]

Cucumber::Rake::Task.new(:cucumber) do |t|
  t.fork = false
  t.cucumber_opts = ["--format", (ENV["CUCUMBER_FORMAT"] || "progress")]
end

RSpec::Core::RakeTask.new(:spec)
