if RUBY_VERSION < "2.2.0"
  appraise 'rails32' do
    gem 'rails', '~> 3.2.21'
  end
end

appraise 'rails40' do
  gem 'rails', '~> 4.0.13'
  gem 'test-unit'
  gem 'mime-types', '~> 2.99'
end

appraise 'rails41' do
  gem 'rails', '~> 4.1.9'
  gem 'mime-types', '~> 2.99'
end

appraise 'rails42' do
  gem 'rails', '~> 4.2.0'
  gem 'mime-types', '~> 2.99'
end

if RUBY_VERSION >= "2.2.0"
  appraise "rails50" do
    gem "rails", "~> 5.0.0.beta3"
    gem "rails-controller-testing"
    gem "rspec-rails", "~> 3.5.0.beta1"
  end
end
