require 'rake'
require 'rake/testtask'
 
test_files_pattern = 'test/rails_root/test/{unit,functional,other}/**/*_test.rb'
namespace :test do
  Rake::TestTask.new(:all => 'generator:tests') do |t|
    t.libs << 'lib'
    t.pattern = test_files_pattern
    t.verbose = false
  end
end

namespace :generator do
  desc "Run the generator on the tests"
  task :tests do
    system "mkdir -p test/rails_root/vendor/plugins/clearance"
    system "cp -R generators test/rails_root/vendor/plugins/clearance"
    system "cd test/rails_root; ./script/generate clearance"
  end
end

desc "Run the test suite"
task :default => 'test:all'
 
begin
  require 'rubygems'
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "clearance"
    s.summary = "Simple, complete Rails authentication."
    s.email = "dcroak@thoughtbot.com"
    s.homepage = "http://github.com/thoughtbot/clearance"
    s.description = "Simple, complete Rails authentication scheme."
    s.authors = ["thoughtbot, inc.", "Josh Nichols", "Mike Breen"]
    s.files = FileList["[A-Z]*", "{generators,lib,test}/**/*"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
