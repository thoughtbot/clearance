require 'rake'
require 'rake/testtask'
require 'date'

test_files_pattern = 'test/rails_root/test/{unit,functional,other}/**/*_test.rb'
Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.pattern = test_files_pattern
  t.verbose = false
end

desc "Run the test suite"
task :default => :test

spec = Gem::Specification.new do |s|
  s.name = "clearance"
  s.summary = "Simple, complete Rails authentication."
  s.email = "dcroak@thoughtbot.com"
  s.homepage = "http://github.com/thoughtbot/clearance"
  s.description = "Simple, complete Rails authentication scheme."
  s.authors = ["thoughtbot, inc.", "Josh Nichols", "Mike Breen"]
  s.files = FileList["[A-Z]*", "{generators,lib,test}/**/*"]
end
