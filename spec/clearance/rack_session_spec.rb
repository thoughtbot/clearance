require 'spec_helper'

describe Clearance::RackSession do
  it 'injects a clearance session into the environment' do
    headers = { 'X-Roaring-Lobster' => 'Red' }
    app = Rack::Builder.new do
      use Clearance::RackSession
      run lambda { |env| Rack::Response.new(env[:clearance], 200, headers).finish }
    end

    env = Rack::MockRequest.env_for('/')
    expected_session = "the session"
    allow(expected_session).to receive(:add_cookie_to_headers)
    allow(Clearance::Session).to receive(:new).
      with(env).
      and_return(expected_session)

    response = Rack::MockResponse.new(*app.call(env))

    expect(response.body).to eq expected_session
    expect(expected_session).to have_received(:add_cookie_to_headers).
      with(hash_including(headers))
  end
end
