rails_versions = %w(
  4.2
  5.0
  5.1
  5.2
)

rails_versions.each do |version|
  appraise "rails_#{version}" do
    gem "rails", "~> #{version}.0"
    if Gem::Version.new(version) >= Gem::Version.new("5.0")
      gem "rails-controller-testing"
    end
  end
end
