require 'spec_helper'

describe Clearance::Token do
  it 'is a random hex string' do
    token = 'my_token'
    allow(SecureRandom).to receive(:hex).with(20).and_return(token)

    expect(Clearance::Token.new).to eq token
  end
end
