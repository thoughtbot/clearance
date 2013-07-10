$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'clearance/version'
require 'date'

Gem::Specification.new do |s|
  s.name = %q{clearance}
  s.version = Clearance::VERSION
  s.authors = [
    'Dan Croak', 'Mike Burns', 'Jason Morrison', 'Joe Ferris', 'Eugene Bolshakov',
    'Nick Quaranto', 'Josh Nichols', 'Mike Breen', 'Jon Yurek', 'Chad Pytel'
  ]
  s.email = %q{support@thoughtbot.com}
  s.homepage = %q{http://github.com/thoughtbot/clearance}
  s.summary = %q{Rails authentication & authorization with email & password.}
  s.description = %q{Rails authentication & authorization with email & password.}

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {features,spec}/*`.split("\n")
  s.extra_rdoc_files = %w(LICENSE README.md)
  s.rdoc_options = ['--charset=UTF-8']
  s.require_paths = ['lib']

  s.required_ruby_version = Gem::Requirement.new('>= 1.9.2')

  s.add_dependency 'bcrypt-ruby'
  s.add_dependency 'email_validator', '~> 1.4'
  s.add_dependency 'rails', '>= 3.1'
end
