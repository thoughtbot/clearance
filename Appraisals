if RUBY_VERSION >= '1.9.3'
  rails_versions = ['~> 3.2.13', '~> 4.0.0']
else
  rails_versions = ['~> 3.1.12']
end

rails_versions.each do |rails_version|
  appraise "rails#{rails_version.slice(/\d+\.\d+/)}" do
    gem 'rails', rails_version
  end
end
