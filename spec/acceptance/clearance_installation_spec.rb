require "spec_helper"

describe "Clearance Installation" do
  around do |example|
    Dir.chdir("tmp") do
      FileUtils.rm_rf("testapp")
      example.run
    end
  end

  it "can successfully run specs" do
    app_name = "testapp"
    generate_test_app(app_name)

    Dir.chdir(app_name) do
      configure_test_app
      install_dependencies
      configure_rspec
      install_clearance
      run_specs
    end
  end

  def generate_test_app(app_name)
    successfully "bundle exec rails new #{app_name} \
       --skip-gemfile \
       --skip-bundle \
       --skip-git \
       --skip-javascript \
       --skip-sprockets \
       --skip-keeps"

    FileUtils.rm_f("public/index.html")
    FileUtils.rm_f("app/views/layouts/application.html.erb")
  end

  def testapp_templates
    File.expand_path("../../app_templates/testapp/", __FILE__)
  end

  def configure_test_app
    FileUtils.rm_f("public/index.html")
    FileUtils.rm_f("app/views/layouts/application.html.erb")
    FileUtils.cp_r(testapp_templates, "..")
  end

  def install_dependencies
    successfully "bundle install --local"
  end

  def configure_rspec
    successfully "bundle exec rails generate rspec:install"
  end

  def install_clearance
    successfully "bundle exec rails generate clearance:install"
    successfully "bundle exec rails generate clearance:specs"
    successfully "bundle exec rake db:migrate db:test:prepare"
  end

  def run_specs
    successfully "bundle exec rspec", false
  end

  def successfully(command, silent = true)
    if silent
      silencer = "1>/dev/null"
    else
      silencer = ""
    end

    return_value = Bundler.with_clean_env do
      system("#{command} #{silencer}")
    end

    expect(return_value).to eq true
  end
end
