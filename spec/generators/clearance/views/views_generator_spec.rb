require "spec_helper"
require "generators/clearance/views/views_generator"

describe Clearance::Generators::ViewsGenerator, :generator do
  it "copies clearance views to the host application" do
    run_generator

    views = %w(
      clearance_mailer/change_password.html.erb
      clearance_mailer/change_password.text.erb
      layouts/application.html.erb
      passwords/create.html.erb
      passwords/edit.html.erb
      passwords/new.html.erb
      sessions/_form.html.erb
      sessions/new.html.erb
      users/_form.html.erb
      users/new.html.erb
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
