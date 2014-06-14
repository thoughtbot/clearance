RSpec.configure do |config|
  config.before :suite, type: :feature do
    Dir.chdir("spec/dummy") do
      `git init . && git add . && git commit -m "commit"`
      `bin/rake db:schema:load`
      `bin/rails g clearance:install`
      `RAILS_ENV=test bin/rake db:migrate`
    end

    Rails.application.reload_routes!
  end

  config.after :suite, type: :feature do
    Dir.chdir("spec/dummy") do
      `git reset --hard && git clean -xfd && rm -rf .git`
    end
  end
end
