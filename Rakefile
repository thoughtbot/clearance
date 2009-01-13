require 'rake'
require 'rake/testtask'
 
test_files_pattern = 'test/rails_root/test/{unit,functional,other}/**/*_test.rb'
namespace :test do
  Rake::TestTask.new(:all => ['generator:cleanup', 'generator:generate']) do |t|
    t.libs << 'lib'
    t.pattern = test_files_pattern
    t.verbose = false
  end
end

namespace :generator do
  desc "Cleans up the test app before running the generator"
  task :cleanup do
    FileList["generators/clearance/templates/**/*.*"].each do |f|
      file = "test/rails_root/#{f.gsub("generators/clearance/templates/",'')}"
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

spec = Gem::Specification.new do |s|
  s.name = "clearance"
  s.version = '0.3.7'
  s.summary = "Simple, complete Rails authentication."
  s.email = "support@thoughtbot.com"
  s.homepage = "http://github.com/thoughtbot/clearance"
  s.description = "Simple, complete Rails authentication scheme."
  s.authors = ["thoughtbot, inc.", "Josh Nichols", "Mike Breen"]
  s.files = FileList["[A-Z]*", "{generators,lib}/**/*"]
end

desc "Generate a gemspec file"
task :gemspec do
  File.open("#{spec.name}.gemspec", 'w') do |f|
    f.write spec.to_yaml
  end
end
