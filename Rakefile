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

namespace :generator do
  task :templates do
    app_files = FileList["test/rails_root/app/{controllers,models,views}/**/*"]
    app_files.reject! { |file| file.include?("test/rails_root/app/views/layouts") }
    test_files = FileList["test/rails_root/test/{functional,unit}/**/*"]
    test_files += ["test/rails_root/test/factories.rb"]
    files = test_files + app_files
    templates_path = "generators/clearance/templates"
    system `rm -rf #{templates_path}`
    system `mkdir #{templates_path}`
    ["app", "app/controllers", "app/models", "app/views",
     "test", "test/functional", "test/unit"].each do |directory|
      system `mkdir #{templates_path}/#{directory}`
    end
    files.each do |file|
      template = "generators/clearance/templates/#{file.gsub("test/rails_root/", "")}"
      if File.directory?(file)
        system `rm -rf #{template}`
        system `mkdir #{template}`
      else
        system `rm #{template}` if File.exists?(template)
        system `cp #{file} #{template}`
      end
    end
  end
end
