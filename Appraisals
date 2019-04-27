rails_versions = %w(
  5.0
  5.1
  5.2
)

if RUBY_VERSION < "2.6"
  # Rails 4.x + Ruby 2.6 raises a ThreadError and tests will break
  # https://github.com/rails/rails/issues/34790
  rails_versions.prepend(4.2)
end

rails_versions.each do |version|
  appraise "rails_#{version}" do
    gem "railties", "~> #{version}.0"
    if Gem::Version.new(version) >= Gem::Version.new("5.0")
      gem "rails-controller-testing"
    end
  end
end
