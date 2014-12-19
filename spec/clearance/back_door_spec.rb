require 'spec_helper'

describe Clearance::BackDoor do
  it 'signs in as a given user' do
    user_id = '123'
    user = double("user")
    allow(User).to receive(:find).with(user_id).and_return(user)
    env = env_for_user_id(user_id)
    back_door = Clearance::BackDoor.new(mock_app)

    result = back_door.call(env)

    expect(env[:clearance]).to have_received(:sign_in).with(user)
    expect(result).to eq mock_app.call(env)
  end

  it 'delegates directly without a user' do
    env = env_without_user_id
    back_door = Clearance::BackDoor.new(mock_app)

    result = back_door.call(env)

    expect(env[:clearance]).not_to have_received(:sign_in)
    expect(result).to eq mock_app.call(env)
  end

  def env_without_user_id
    env_for_user_id('')
  end

  def env_for_user_id(user_id)
    clearance = double("clearance", sign_in: true)
    Rack::MockRequest.env_for("/?as=#{user_id}").merge(clearance: clearance)
  end

  def mock_app
    lambda { |env| [200, {}, ['okay']] }
  end
end
