if RUBY_VERSION < "2.2.0"
  appraise 'rails32' do
    gem 'rails', '~> 3.2.21'
  end
end

appraise 'rails40' do
  gem 'rails', '~> 4.0.13'
  gem 'test-unit'
end

appraise 'rails41' do
  gem 'rails', '~> 4.1.9'
end

appraise 'rails42' do
  gem 'rails', '~> 4.2.0'
end

if RUBY_VERSION >= "2.2.0"
  appraise "rails50" do
    gem "rails", git: "https://github.com/rails/rails"
    gem "rails-controller-testing"
    gem "rspec-rails", github: "rspec/rspec-rails"
    gem "rspec-support", github: "rspec/rspec-support"
    gem "rspec-core", github: "rspec/rspec-core"
    gem "rspec-mocks", github: "rspec/rspec-mocks"
    gem "rspec-expectations", github: "rspec/rspec-expectations"
    gem "rspec", github: "rspec/rspec"
  end
end
