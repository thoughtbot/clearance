require 'rake'
require 'rake/testtask'
 
test_files_pattern = 'test/rails_root/test/{unit,functional,other}/**/*_test.rb'
namespace :test do
  Rake::TestTask.new(:all => ['generator:cleanup', 'generator:generate']) do |task|
    task.libs << 'lib'
    task.pattern = test_files_pattern
    task.verbose = false
  end
end

namespace :generator do
  desc "Cleans up the test app before running the generator"
  task :cleanup do
    FileList["generators/clearance/templates/**/*.*"].each do |each|
      file = "test/rails_root/#{each.gsub("generators/clearance/templates/",'')}"
      File.delete(file) if File.exists?(file)
    end
    
    FileUtils.rm_rf("test/rails_root/db/migrate")
    FileUtils.rm_rf("test/rails_root/vendor/plugins/clearance")
    system "cp generators/clearance/templates/config/routes.rb test/rails_root/config"      
    system "mkdir -p test/rails_root/vendor/plugins/clearance"
    system "cp -R generators test/rails_root/vendor/plugins/clearance"  
  end

  desc "Run the generator on the tests"
  task :generate do
    system "cd test/rails_root && ./script/generate clearance"
  end
end

desc "Run the test suite"
task :default => 'test:all'

gem_spec = Gem::Specification.new do |gem_spec|
  gem_spec.name        = "clearance"
  gem_spec.version     = "0.4.0"
  gem_spec.summary     = "Simple, complete Rails authentication."
  gem_spec.email       = "support@thoughtbot.com"
  gem_spec.homepage    = "http://github.com/thoughtbot/clearance"
  gem_spec.description = "Simple, complete Rails authentication scheme."
  gem_spec.authors     = ["thoughtbot, inc.", "Dan Croak", "Mike Burns", "Jason Morrison",
                          "Eugene Bolshakov", "Josh Nichols", "Mike Breen"]
  gem_spec.files       = FileList["[A-Z]*", "{generators,lib,shoulda_macros,rails}/**/*"]
end

desc "Generate a gemspec file"
task :gemspec do
  File.open("#{gem_spec.name}.gemspec", 'w') do |f|
    f.write gem_spec.to_yaml
  end
end
