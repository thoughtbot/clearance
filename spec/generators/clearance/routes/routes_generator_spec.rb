require "spec_helper"
require "generators/clearance/routes/routes_generator"

describe Clearance::Generators::RoutesGenerator, :generator do
  it "adds clearance routes to host application routes" do
    provide_existing_routes_file

    routes = file("config/routes.rb")

    run_generator

    expect(routes).to have_correct_syntax
    expect(routes).to contain(
      'get "/sign_in" => "clearance/sessions#new", as: "sign_in"'
    )
  end
end
