rails_versions = ['~> 3.2.13', '~> 4.0.0']

rails_versions.each do |rails_version|
  appraise "rails#{rails_version.slice(/\d+\.\d+/)}" do
    gem 'rails', rails_version
  end
end
