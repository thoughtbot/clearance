# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "clearance/version"

Gem::Specification.new do |spec|
  spec.name = "Clearance"
  spec.version = Clearance::VERSION
  spec.authors = ["Derek Prior", "Goose Mongeau"]
  spec.email = ["derekprior@gmail.com", "halogenandtoast@gmail.com"]
  spec.summary = "Rails authentication with email & password."
  spec.description = "Rails authentication with email & password."
  spec.homepage = "https://github.com/thoughtbot/clearance"
  spec.license = "MIT"

  spec.files = `git ls-files -z`.split("\x0")
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "monban", "~> 0.0.14"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rspec-rails", ">= 3.0.0"
  spec.add_development_dependency "capybara", ">= 2.3.0"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "factory_girl_rails"
end
