require 'spec_helper'

describe Clearance::RackSession do
  it "injects a clearance session into the environment" do
    expected_session = "the session"
    expected_session.stubs(:add_cookie_to_headers)
    Clearance::Session.stubs(:new => expected_session)
    headers = { "X-Roaring-Lobster" => "Red" }

    app = Rack::Builder.new do
      use Clearance::RackSession
      run lambda { |env| Rack::Response.new(env[:clearance], 200, headers).finish }
    end

    env = Rack::MockRequest.env_for("/")

    response = Rack::MockResponse.new(*app.call(env))

    Clearance::Session.should have_received(:new).with(env)
    response.body.should == expected_session
    expected_session.should have_received(:add_cookie_to_headers).with(has_entries(headers))
  end
end
