require 'date'

Gem::Specification.new do |s|
  s.name     = %q{clearance}
  s.version  = IO.read(File.join(File.dirname(__FILE__), 'VERSION'))
  s.email    = %q{support@thoughtbot.com}
  s.homepage = %q{http://github.com/thoughtbot/clearance}

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dan Croak", "Mike Burns", "Jason Morrison", "Joe Ferris", "Eugene Bolshakov", "Nick Quaranto", "Josh Nichols", "Mike Breen", "Marcel G\303\266rner", "Bence Nagy", "Ben Mabey", "Eloy Duran", "Tim Pope", "Mihai Anca", "Mark Cornick", "Shay Arnett", "Jon Yurek", "Chad Pytel"]
  s.date        = Date.today.to_s
  s.summary     = %q{Rails authentication with email & password.}
  s.description = %q{Rails authentication with email & password.}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.files      = Dir['[A-Z]*', 'app/**/*', 'config/**/*', 'lib/**/*']
  s.test_files = Dir['spec/**/*', 'test/**/*']

  s.rdoc_options     = ["--charset=UTF-8"]
  s.require_paths    = ["lib"]
  s.rubygems_version = %q{1.3.7}

  s.add_dependency('rails',  '~> 3.0.0')
  s.add_dependency('diesel', '~> 0.1.4')

  s.add_development_dependency('rspec',    '~> 1.3.0')
  s.add_development_dependency('cucumber', '~> 0.10.0')

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3
  end
end

