require "spec_helper"
require "generators/clearance/views/views_generator"

describe Clearance::Generators::ViewsGenerator, :generator do
  it "copies clearance views to the host application" do
    run_generator

    views = %w(
      clearance/mailer/change_password.html.erb
      clearance/mailer/change_password.text.erb
      clearance/passwords/create.html.erb
      clearance/passwords/edit.html.erb
      clearance/passwords/new.html.erb
      clearance/sessions/_form.html.erb
      clearance/sessions/new.html.erb
      clearance/users/_form.html.erb
      clearance/users/new.html.erb
      layouts/application.html.erb
    )

    view_files = views.map { |view| file("app/views/#{view}") }

    view_files.each do |each|
      expect(each).to exist
      expect(each).to have_correct_syntax
    end
  end

  it "copies clearance locales to the host application" do
    run_generator

    locale = file("config/locales/clearance.en.yml")

    expect(locale).to exist
  end
end
