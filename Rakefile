require 'rake'
require 'rake/testtask'
require 'date'
require 'lib/clearance/version'

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
  s.authors = ["thoughtbot, inc.", "Dan Croak", "Josh Nichols", "Mike Breen", "Mike Burns", "Jason Morrison"]
  s.files = FileList["[A-Z]*", "{generators,lib,test}/**/*"]
end

desc "Generate a gemspec file for GitHub"
task :gemspec => 'version:calculate' do
  date = DateTime.now
  spec.date = "#{date.year}-#{date.month}-#{date.day}"
  
  File.open("#{spec.name}.gemspec", 'w') do |f|
    f.write spec.to_ruby
  end
end

desc "Displays the current version"
task :version => 'version:calculate' do
  puts spec.version
end

namespace :version do
  desc "Determine's the version based on Clearance::Version"
  task :calculate do
    spec.version ||= "#{Clearance::Version::MAJOR}.#{Clearance::Version::MINOR}.#{Clearance::Version::PATCH}"
  end
  
  namespace :bump do
    def bump_gemspec(spec, major, minor, patch)
      File.open("lib/clearance/version.rb", 'w') do |file|
        file.write <<-END
module Clearance
  module Version
    MAJOR = #{major}
    MINOR = #{minor}
    PATCH = #{patch}
  end
end
        END
      end

      spec.version = "#{major}.#{minor}.#{patch}"
      Rake::Task["gemspec"].invoke
      puts "Gem bumped to #{spec.version}"
    end
    
    desc "Bump the gemspec a major version."
    task :major do
      major = Clearance::Version::MAJOR + 1
      bump_gemspec(spec, major, 0, 0)
    end
    
    desc "Bump the gemspec a minor version."
    task :minor do
      minor = Clearance::Version::MINOR + 1
      bump_gemspec(spec, Clearance::Version::MAJOR, minor, 0)
    end
    
    desc "Bump the gemspec a patch version."
    task :patch do
      patch = Clearance::Version::PATCH + 1
      bump_gemspec(spec, Clearance::Version::MAJOR, Clearance::Version::MINOR, patch)
    end
  end
end
