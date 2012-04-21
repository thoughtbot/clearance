$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'clearance/version'
require 'date'

Gem::Specification.new do |s|
  s.name     = %q{clearance}
  s.version  = Clearance::VERSION
  s.email    = %q{support@thoughtbot.com}
  s.homepage = %q{http://github.com/thoughtbot/clearance}

  s.authors = ["Dan Croak", "Mike Burns", "Jason Morrison", "Joe Ferris", "Eugene Bolshakov", "Nick Quaranto", "Josh Nichols", "Mike Breen", "Jon Yurek", "Chad Pytel"]
  s.date        = Date.today.to_s
  s.summary     = %q{Rails authentication & authorization with email & password.}
  s.description = %q{Rails authentication & authorization with email & password.}
  s.extra_rdoc_files = %w(LICENSE README.md)
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,features}/*`.split("\n")

  s.rdoc_options     = ["--charset=UTF-8"]
  s.require_paths    = ["lib"]

  s.add_dependency('rails',  '>= 3.0')
  s.add_dependency('diesel', '~> 0.1.5')

  s.add_development_dependency('bundler',        '~> 1.1.0')
  s.add_development_dependency('appraisal',      '~> 0.4.1')
  s.add_development_dependency('cucumber-rails', '~> 1.1.1')
  s.add_development_dependency('rspec-rails',    '~> 2.9.0')
  s.add_development_dependency('sqlite3')
  s.add_development_dependency('bourne', '~> 1.1.2')
  s.add_development_dependency('timecop')
  s.add_development_dependency('capybara', '~> 1.1.2')
  s.add_development_dependency('factory_girl_rails', '~> 3.1.0')
  s.add_development_dependency('shoulda-matchers', '~> 1.1.0')
  s.add_development_dependency('database_cleaner')
  s.add_development_dependency('launchy')
  s.add_development_dependency('aruba', '~> 0.4.11')
end
