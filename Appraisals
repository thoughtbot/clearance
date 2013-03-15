if RUBY_VERSION >= '2.0'
  rails_versions = ['3.2.13.rc2']
else
  rails_versions = ['3.0.20', '3.1.11', '3.2.12']
end

rails_versions.each do |rails_version|
  appraise "#{rails_version}" do
    gem 'rails', rails_version
  end
end
