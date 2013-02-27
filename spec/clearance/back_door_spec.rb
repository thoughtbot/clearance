require 'spec_helper'

describe Clearance::BackDoor do
  it 'signs in as a given user' do
    user_id = '123'
    user = stub('user')
    User.stubs(:find).with(user_id).returns(user)
    env = env_for_user_id(user_id)
    back_door = Clearance::BackDoor.new(mock_app)

    result = back_door.call(env)

    env[:clearance].should have_received(:sign_in).with(user)
    result.should eq mock_app.call(env)
  end

  it 'delegates directly without a user' do
    env = env_without_user_id
    back_door = Clearance::BackDoor.new(mock_app)

    result = back_door.call(env)

    env[:clearance].should have_received(:sign_in).never
    result.should eq mock_app.call(env)
  end

  def env_without_user_id
    env_for_user_id('')
  end

  def env_for_user_id(user_id)
    clearance = stub('clearance', sign_in: true)
    Rack::MockRequest.env_for("/?as=#{user_id}").merge(clearance: clearance)
  end

  def mock_app
    lambda { |env| [200, {}, ['okay']] }
  end
end
