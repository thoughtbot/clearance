if RUBY_VERSION >= '2.0'
  rails_versions = ['~> 3.2.13']
else
  rails_versions = ['~> 3.0.20', '~> 3.1.12', '~> 3.2.13']
end

rails_versions.each do |rails_version|
  appraise "rails#{rails_version.slice(/\d+\.\d+/)}" do
    gem 'rails', rails_version
  end
end
