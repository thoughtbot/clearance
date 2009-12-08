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
    generators.each do |generator|
      FileList["generators/#{generator}/templates/**/*.*"].each do |each|
        file = "test/rails_root/#{each.gsub("generators/#{generator}/templates/",'')}"
        File.delete(file) if File.exists?(file)
      end
    end

    FileList["test/rails_root/db/**/*"].each do |each| 
      FileUtils.rm_rf(each)
    end

    FileUtils.rm_rf("test/rails_root/vendor/plugins/clearance")
    FileUtils.mkdir_p("test/rails_root/vendor/plugins")
    clearance_root = File.expand_path(File.dirname(__FILE__))
    system("ln -s #{clearance_root} test/rails_root/vendor/plugins/clearance")

    FileUtils.rm_rf("test/rails_root/app/views/passwords")
    FileUtils.rm_rf("test/rails_root/app/views/sessions")
    FileUtils.rm_rf("test/rails_root/app/views/users")
  end

  desc "Run the clearance generator"
  task :clearance do
    system "cd test/rails_root && ./script/generate clearance && rake db:migrate db:test:prepare"
  end

  desc "Run the clearance features generator"
  task :clearance_features do
    system "cd test/rails_root && ./script/generate clearance_features"
  end

  desc "Run the clearance views generator"
  task :clearance_views do
    system "cd test/rails_root && ./script/generate clearance_views"
  end
end

desc "Run the test suite"
task :default => ['test:basic', 'test:features',
                  'test:views', 'test:features_for_views']

gem_spec = Gem::Specification.new do |gem_spec|
  gem_spec.name        = "clearance"
  gem_spec.version     = "0.8.4"
  gem_spec.summary     = "Rails authentication with email & password."
  gem_spec.email       = "support@thoughtbot.com"
  gem_spec.homepage    = "http://github.com/thoughtbot/clearance"
  gem_spec.description = "Rails authentication with email & password."
  gem_spec.authors     = ["Dan Croak", "Mike Burns", "Jason Morrison",
                          "Joe Ferris", "Eugene Bolshakov", "Nick Quaranto",
                          "Josh Nichols", "Mike Breen", "Marcel Görner",
                          "Bence Nagy", "Ben Mabey", "Eloy Duran",
                          "Tim Pope", "Mihai Anca", "Mark Cornick",
                          "Shay Arnett", "Jon Yurek", "Chad Pytel"]
  gem_spec.files       = FileList["[A-Z]*", "{app,config,generators,lib,shoulda_macros,rails}/**/*"]
end

desc "Generate a gemspec file"
task :gemspec do
  File.open("#{gem_spec.name}.gemspec", 'w') do |f|
    f.write gem_spec.to_yaml
  end
end

