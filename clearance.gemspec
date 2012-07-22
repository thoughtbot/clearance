$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'clearance/version'
require 'date'

Gem::Specification.new do |s|
  s.add_dependency 'bcrypt-ruby'
  s.add_dependency 'diesel', '0.1.5'
  s.add_dependency 'rails', '>= 3.0'
  s.add_development_dependency 'appraisal', '0.4.1'
  s.add_development_dependency 'aruba', '0.4.11'
  s.add_development_dependency 'bourne', '1.1.2'
  s.add_development_dependency 'bundler', '1.1.3'
  s.add_development_dependency 'capybara', '1.1.2'
  s.add_development_dependency 'cucumber-rails', '1.1.1'
  s.add_development_dependency 'database_cleaner', '0.8.0'
  s.add_development_dependency 'factory_girl_rails', '3.5.0'
  s.add_development_dependency 'rspec-rails', '2.11.0'
  s.add_development_dependency 'shoulda-matchers', '1.2.0'
  s.add_development_dependency 'sqlite3', '1.3.6'
  s.add_development_dependency 'timecop', '0.3.5'
  s.authors = [
    'Dan Croak', 'Mike Burns', 'Jason Morrison', 'Joe Ferris', 'Eugene Bolshakov',
    'Nick Quaranto', 'Josh Nichols', 'Mike Breen', 'Jon Yurek', 'Chad Pytel'
  ]
  s.date = Date.today.to_s
  s.description = %q{Rails authentication & authorization with email & password.}
  s.email = %q{support@thoughtbot.com}
  s.extra_rdoc_files = %w(LICENSE README.md)
  s.files = `git ls-files`.split('\n')
  s.homepage = %q{http://github.com/thoughtbot/clearance}
  s.name = %q{clearance}
  s.rdoc_options = ['--charset=UTF-8']
  s.require_paths = ['lib']
  s.summary = %q{Rails authentication & authorization with email & password.}
  s.test_files = `git ls-files -- {features,spec}/*`.split('\n')
  s.version = Clearance::VERSION
end
