require 'spec_helper'

describe Clearance::Token do
  it 'is a random hex string' do
    token = 'my_token'
    SecureRandom.stubs(:hex).with(20).returns(token)

    expect(Clearance::Token.new).to eq token
  end
end
