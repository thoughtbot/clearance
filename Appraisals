rails_versions = %w(
  5.0
  5.1
  5.2
)

rails_versions.each do |version|
  appraise "rails_#{version}" do
    gem "railties", "~> #{version}.0"
    gem "rails-controller-testing"
  end
end
