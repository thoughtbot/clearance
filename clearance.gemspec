require 'date'

Gem::Specification.new do |s|
  s.name     = %q{clearance}
  s.version  = IO.read(File.join(File.dirname(__FILE__), 'VERSION'))
  s.email    = %q{support@thoughtbot.com}
  s.homepage = %q{http://github.com/thoughtbot/clearance}

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dan Croak", "Mike Burns", "Jason Morrison", "Joe Ferris", "Eugene Bolshakov", "Nick Quaranto", "Josh Nichols", "Mike Breen", "Jon Yurek", "Chad Pytel"]
  s.date        = Date.today.to_s
  s.summary     = %q{Rails authentication & authorization with email & password.}
  s.description = %q{Rails authentication & authorization with email & password.}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,features}/*`.split("\n")

  s.rdoc_options     = ["--charset=UTF-8"]
  s.require_paths    = ["lib"]
  s.rubygems_version = %q{1.3.7}

  s.add_dependency('rails',  '>= 3.0')
  s.add_dependency('diesel', '~> 0.1.5')

  s.add_development_dependency('bundler',        '~> 1.1.0')
  s.add_development_dependency('appraisal',      '~> 0.3.8')
  s.add_development_dependency('cucumber-rails', '~> 1.1.1')
  s.add_development_dependency('rspec-rails',    '~> 2.6.0')
  s.add_development_dependency('sqlite3')
  s.add_development_dependency('bourne')
  s.add_development_dependency('timecop')

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3
  end
end

