$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'clearance/version'

Gem::Specification.new do |s|
  s.add_dependency 'bcrypt', '>= 3.1.1'
  s.add_dependency 'argon2', '~> 2.0', '>= 2.0.2'
  s.add_dependency 'email_validator', '~> 2.0'
  s.add_dependency 'railties', '>= 5.0'
  s.add_dependency 'activemodel', '>= 5.0'
  s.add_dependency 'activerecord', '>= 5.0'
  s.add_dependency 'actionmailer', '>= 5.0'
  s.authors = [
    'Dan Croak',
    'Eugene Bolshakov',
    'Mike Burns',
    'Joe Ferris',
    'Nick Quaranto',
    'Josh Nichols',
    'Matt Jankowski',
    'Josh Clayton',
    'Gabe Berke-Williams',
    'Greg Lazarev',
    'Mike Breen',
    'Prem Sichanugrist',
    'Harlow Ward',
    'Ryan McGeary',
    'Derek Prior',
    'Jason Morrison',
    'Galen Frechette',
    'Josh Steiner'
  ]
  s.description = <<-DESCRIPTION
    Clearance is built to support authentication and authorization via an
    email/password sign-in mechanism in applications.

    It provides some core classes commonly used for these features, along with
    some opinionated defaults - but is intended to be easy to override.
  DESCRIPTION
  s.email = 'support@thoughtbot.com'
  s.extra_rdoc_files = %w(LICENSE README.md)
  s.files = `git ls-files`.split("\n")
  s.homepage = 'https://github.com/thoughtbot/clearance'
  s.license = 'MIT'
  s.name = %q{clearance}
  s.rdoc_options = ['--charset=UTF-8']
  s.require_paths = ['lib']
  s.required_ruby_version = Gem::Requirement.new('>= 2.4.0')
  s.summary = 'Rails authentication & authorization with email & password.'
  s.test_files = `git ls-files -- {spec}/*`.split("\n")
  s.version = Clearance::VERSION
end
