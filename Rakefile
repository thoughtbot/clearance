require 'rake'
require 'rake/testtask'
require 'cucumber/rake/task'

namespace :test do
  Rake::TestTask.new(:all => ["generator:cleanup",
                              "generator:generate"]) do |task|
    task.libs << "lib"
    task.libs << "test"
    task.pattern = "test/**/*_test.rb"
    task.verbose = false
  end

  Cucumber::Rake::Task.new(:features) do |t|
    t.cucumber_opts   = "--format progress"
    t.feature_pattern = "test/rails_root/features/*.feature"
  end
end

generators = %w(clearance clearance_features)

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
  end

  desc "Run the generator on the tests"
  task :generate do
    generators.each do |generator|
      system "cd test/rails_root && ./script/generate #{generator} && rake db:migrate db:test:prepare"
    end
  end
end

desc "Run the test suite"
task :default => ['test:all', 'test:features']

gem_spec = Gem::Specification.new do |gem_spec|
  gem_spec.name        = "clearance"
  gem_spec.version     = "0.6.5"
  gem_spec.summary     = "Rails authentication with email & password."
  gem_spec.email       = "support@thoughtbot.com"
  gem_spec.homepage    = "http://github.com/thoughtbot/clearance"
  gem_spec.description = "Rails authentication with email & password."
  gem_spec.authors     = ["Dan Croak", "Mike Burns", "Jason Morrison",
                          "Joe Ferris", "Eugene Bolshakov", "Nick Quaranto",
                          "Josh Nichols", "Mike Breen", "Marcel Görner",
                          "Bence Nagy", "Ben Mabey", "Eloy Duran",
                          "Tim Pope", "Mihai Anca", "Mark Cornick",
                          "Shay Arnett"]
  gem_spec.files       = FileList["[A-Z]*", "{app,config,generators,lib,shoulda_macros,rails}/**/*"]
end

desc "Generate a gemspec file"
task :gemspec do
  File.open("#{gem_spec.name}.gemspec", 'w') do |f|
    f.write gem_spec.to_yaml
  end
end
