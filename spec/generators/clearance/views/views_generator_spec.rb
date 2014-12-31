require "spec_helper"
require "generators/clearance/views/views_generator"

describe Clearance::Generators::ViewsGenerator, :generator do
  it "copies clearance views to the host application" do
    run_generator

    views = %w(
      clearance_mailer/change_password
      layouts/application
      passwords/create
      passwords/edit
      passwords/new
      sessions/_form
      sessions/new
      users/_form
      users/new
    )

    view_files = views.map { |view| file("app/views/#{view}.html.erb") }

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
