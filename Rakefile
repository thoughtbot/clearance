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
  s.version = "#{Clearance::Version::MAJOR}.#{Clearance::Version::MINOR}.#{Clearance::Version::PATCH}"
  date = DateTime.now
  s.date = "#{date.year}-#{date.month}-#{date.day}"
  s.summary = "Simple, complete Rails authentication."
  s.email = "dcroak@thoughtbot.com"
  s.homepage = "http://github.com/thoughtbot/clearance"
  s.description = "Simple, complete Rails authentication scheme."
  s.authors = ["thoughtbot, inc.", "Dan Croak", "Josh Nichols", "Mike Breen", "Mike Burns", "Jason Morrison"]
  s.files = FileList["[A-Z]*", "{generators,lib,test}/**/*"]
end

namespace :gemspec do
  desc "Generate a gemspec file for GitHub"
  task :write do
    File.open("#{spec.name}.gemspec", 'w') do |f|
      f.write spec.to_ruby
    end
  end
end

namespace :version do
  namespace :bump do
    desc "Bump the gemspec a major version."
    task :major do
      major = Clearance::Version::MAJOR + 1
      File.open("lib/clearance/version.rb", 'w') do |file|
        file.write <<-END
module Clearance
  module Version
    MAJOR = #{major}
    MINOR = 0
    PATCH = 0
  end
end
        END
      end
      
      spec.version = "#{major}.0.0"
      puts "Version bumped to #{spec.version}"
      
      Rake::Task["gemspec:write"].invoke
      puts "Gemspec updated"
    end
    
    desc "Bump the gemspec a minor version."
    task :minor do
      minor = Clearance::Version::MINOR + 1
      File.open("lib/clearance/version.rb", 'w') do |file|
        file.write <<-END
module Clearance
  module Version
    MAJOR = #{Clearance::Version::MAJOR}
    MINOR = #{minor}
    PATCH = 0
  end
end
        END
      end
      
      spec.version = "#{Clearance::Version::MAJOR}.#{minor}.0"
      puts "Version bumped to #{spec.version}"
      
      Rake::Task["gemspec:write"].invoke
      puts "Gemspec updated"
    end
    
    desc "Bump the gemspec a patch version."
    task :patch do
      patch = Clearance::Version::PATCH + 1
      File.open("lib/clearance/version.rb", 'w') do |file|
        file.write <<-END
module Clearance
  module Version
    MAJOR = #{Clearance::Version::MAJOR}
    MINOR = #{Clearance::Version::MINOR}
    PATCH = #{patch}
  end
end
        END
      end
      
      spec.version = "#{Clearance::Version::MAJOR}.#{Clearance::Version::MINOR}.#{patch}"
      puts "Version bumped to #{spec.version}"
      
      Rake::Task["gemspec:write"].invoke
      puts "Gemspec updated"
    end
  end
end
