rails_versions = %w(
  5.0
  5.1
  5.2
  6.0
)

rails_versions.each do |version|
  appraise "rails_#{version}" do
    gem "railties", "~> #{version}.0"
    gem "rails-controller-testing"

    if Gem::Version.new(version) >= Gem::Version.new("6.0")
      # TODO - Switch to 4.0 gem once release is made
      gem 'capybara'
      gem 'rspec-rails', '~> 4.0.0.beta3'
      gem 'sqlite3'
    else
      gem 'capybara', '>= 2.6.2', '< 3.33.0'
      gem 'rspec-rails', '~> 3.1'
      gem 'sqlite3', '~> 1.3.13'
    end

  end
end
