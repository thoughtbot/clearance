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
      gem 'rspec-rails', '~> 4.0.0.beta2'
      gem 'sqlite3', '~> 1.4.0'
    else
      gem 'sqlite3', '~> 1.3.13'
      gem 'rspec-rails', '~> 3.1'
    end

  end
end
