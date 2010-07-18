# encoding: utf-8

ENV['BUNDLE_GEMFILE'] = File.dirname(__FILE__) + '/test/rails_root/Gemfile'

require 'rake'
require 'rake/testtask'
require 'cucumber/rake/task'
require 'spec/rake/spectask'

namespace :test do
  Rake::TestTask.new(:basic => ["generator:cleanup",
                                "generator:clearance"]) do |task|
    task.libs << "lib"
    task.libs << "test"
    task.pattern = "test/*/*_test.rb"
    task.verbose = false
  end

  Rake::TestTask.new(:views => ["generator:cleanup",
                                "generator:clearance",
                                "generator:clearance_views"]) do |task|
    task.libs << "lib"
    task.libs << "test"
    task.pattern = "test/*/*_test.rb"
    task.verbose = false
  end


  Cucumber::Rake::Task.new(:features => ["generator:cleanup",
                                         "generator:clearance",
                                         "generator:clearance_features"]) do |t|
    t.cucumber_opts   = "--format progress"
    t.profile = 'features'
  end

  Cucumber::Rake::Task.new(:features_for_views => ["generator:cleanup",
                                                   "generator:clearance",
                                                   "generator:clearance_features",
                                                   "generator:clearance_views"]) do |t|
    t.cucumber_opts   = "--format progress"
    t.profile = 'features_for_views'
  end
end

namespace :spec do
  Spec::Rake::SpecTask.new(:basic => %w(spec:generator:cleanup spec:generator:clearance)) do |task|
    task.spec_files = FileList['spec/*/*_spec.rb']
  end

  Spec::Rake::SpecTask.new(:views => %w(spec:generator:cleanup spec:generator:clearance spec:generator:clearance_views)) do |task|
    task.spec_files = FileList['spec/*/*_spec.rb']
  end

  Cucumber::Rake::Task.new(:features => %w(spec:generator:cleanup spec:generator:clearance spec:generator:clearance_features)) do |task|
    task.cucumber_opts = '--format progress'
    task.profile = 'features_with_rspec'
  end

  Cucumber::Rake::Task.new(:features_for_views => %w(spec:generator:cleanup spec:generator:clearance spec:generator:clearance_features spec:generator:clearance_views)) do |task|
    task.cucumber_opts = '--format progress'
    task.profile = 'features_for_views_with_rspec'
  end

  namespace :generator do
    task :cleanup do
      FileList["spec/rails_root/db/**/*"].each do |each|
        FileUtils.rm_rf(each)
      end

      FileUtils.rm_rf("spec/rails_root/vendor/plugins/clearance")
      FileUtils.rm_rf("spec/rails_root/app/views/passwords")
      FileUtils.rm_rf("spec/rails_root/app/views/sessions")
      FileUtils.rm_rf("spec/rails_root/app/views/users")
      FileUtils.mkdir_p("spec/rails_root/vendor/plugins")
      clearance_root = File.expand_path(File.dirname(__FILE__))
      system("ln -s #{clearance_root} spec/rails_root/vendor/plugins/clearance")
      FileList["spec/rails_root/features/*.feature"].each do |each|
        FileUtils.rm_rf(each)
      end
    end

    task :clearance do
      system "cd spec/rails_root && bundle install && ./script/rails generate clearance && rake db:migrate db:test:prepare"
    end

    task :clearance_features do
      system "cd spec/rails_root && ./script/rails generate clearance_features"
    end

    task :clearance_views do
      system "cd spec/rails_root && ./script/rails generate clearance_views"
    end
  end
end

namespace :generator do
  desc "Cleans up the test app before running the generator"
  task :cleanup do
    FileList["test/rails_root/db/**/*"].each do |each|
      FileUtils.rm_rf(each)
    end

    FileUtils.rm_rf("test/rails_root/app/views/passwords")
    FileUtils.rm_rf("test/rails_root/app/views/sessions")
    FileUtils.rm_rf("test/rails_root/app/views/users")
    FileUtils.mkdir_p("test/rails_root/vendor/plugins")
    clearance_root = File.expand_path(File.dirname(__FILE__))
    FileList["test/rails_root/features/*.feature"].each do |each|
      FileUtils.rm_rf(each)
    end
  end

  desc "Run the clearance generator"
  task :clearance do
    system "cd test/rails_root && bundle install && ./script/rails generate clearance && rake db:migrate db:test:prepare"
  end

  desc "Run the clearance features generator"
  task :clearance_features do
    system "cd test/rails_root && ./script/rails generate clearance_features"
  end

  desc "Run the clearance views generator"
  task :clearance_views do
    system "cd test/rails_root && ./script/rails generate clearance_views"
  end
end

desc "Run the test suite"
task :default => ['test:basic', 'test:features',
                  'test:views', 'test:features_for_views',
                  'spec:basic', 'spec:features',
                  'spec:views', 'spec:features_for_views']
