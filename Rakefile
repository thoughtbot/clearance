# encoding: utf-8

require 'rake'
require 'rake/testtask'
require 'cucumber/rake/task'

namespace :test do
  Rake::TestTask.new(:basic => ["generator:cleanup",
                                "generator:clearance",
                                "generator:clearance_features"]) do |task|
    task.libs << "lib"
    task.libs << "test"
    task.pattern = "test/**/*_test.rb"
    task.verbose = false
  end

  Rake::TestTask.new(:views => ["generator:clearance_views"]) do |task|
    task.libs << "lib"
    task.libs << "test"
    task.pattern = "test/**/*_test.rb"
    task.verbose = false
  end

  Cucumber::Rake::Task.new(:features) do |t|
    t.cucumber_opts   = "--format progress"
    t.profile = 'features'
  end

  Cucumber::Rake::Task.new(:features_for_views) do |t|
    t.cucumber_opts   = "--format progress"
    t.profile = 'features_for_views'
  end
end

generators = %w(clearance clearance_features clearance_views)

namespace :generator do
  desc "Cleans up the test app before running the generator"
  task :cleanup do
    FileList["test/rails_root/db/**/*"].each do |each|
      FileUtils.rm_rf(each)
    end

    FileUtils.rm_rf("test/rails_root/vendor/plugins/clearance")
    FileUtils.mkdir_p("test/rails_root/vendor/plugins")
    clearance_root = File.expand_path(File.dirname(__FILE__))
    system("ln -s #{clearance_root} test/rails_root/vendor/plugins/clearance")
  end

  desc "Run the clearance generator"
  task :clearance do
    system "cd test/rails_root && ./script/generate clearance -f && rake db:migrate db:test:prepare"
  end

  desc "Run the clearance features generator"
  task :clearance_features do
    system "cd test/rails_root && ./script/generate clearance_features -f"
  end

  desc "Run the clearance views generator"
  task :clearance_views do
    system "cd test/rails_root && ./script/generate clearance_views -f"
  end
end

desc "Run the test suite"
task :default => ['test:basic', 'test:features',
                  'test:views', 'test:features_for_views']

require 'jeweler'

Jeweler::Tasks.new do |gem|
  gem.name        = "clearance"
  gem.summary     = "Rails authentication with email & password."
  gem.description = "Rails authentication with email & password."
  gem.email       = "support@thoughtbot.com"
  gem.homepage    = "http://github.com/thoughtbot/clearance"
  gem.authors     = ["Dan Croak", "Mike Burns", "Jason Morrison",
                     "Joe Ferris", "Eugene Bolshakov", "Nick Quaranto",
                     "Josh Nichols", "Mike Breen", "Marcel Görner",
                     "Bence Nagy", "Ben Mabey", "Eloy Duran",
                     "Tim Pope", "Mihai Anca", "Mark Cornick",
                     "Shay Arnett", "Jon Yurek", "Chad Pytel"]
  gem.files       = FileList["[A-Z]*", "{app,config,generators,lib,shoulda_macros,rails}/**/*"]
end

Jeweler::GemcutterTasks.new
