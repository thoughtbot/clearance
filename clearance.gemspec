Gem::Specification.new do |s|
  s.version = "0.3.6"
  s.date = %q{2008-12-29}

  s.name = %q{clearance}
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["thoughtbot, inc.", "Dan Croak", "Mike Burns", "Jason Morrison", "Josh Nichols", "Mike Breen"]
  s.description = %q{Simple, complete Rails authentication scheme.}
  s.email = %q{dcroak@thoughtbot.com}
  s.files = FileList["[A-Z]*", "{generators,lib,rails,test}/**/*"]
  s.homepage = %q{http://github.com/thoughtbot/clearance}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Simple, complete Rails authentication.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2
  end
end
