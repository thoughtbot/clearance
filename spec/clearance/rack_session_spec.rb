require 'spec_helper'

describe Clearance::RackSession do
  it 'injects a clearance session into the environment' do
    expected_session = 'the session'
    allow(Clearance::Session).to receive(:new).and_return(expected_session)

    app = Rack::Builder.new do
      use Clearance::RackSession
      run lambda { |env| Rack::Response.new(env[:clearance], 200, {}).finish }
    end

    env = Rack::MockRequest.env_for('/')

    response = Rack::MockResponse.new(*app.call(env))

    expect(Clearance::Session).to have_received(:new).with(env)
    expect(response.body).to eq expected_session
  end
end
