require "spec_helper"

describe Clearance::Tokenizer do
  it "is able to generate and verify valid token for any given user" do
    user = FactoryBot.create(:user)
    tokenizer = Clearance::Tokenizer.new(user)
    token = tokenizer.generate(user.id)

    expect(token).not_to eq user.id
    expect(tokenizer.valid?(token)).to be_truthy
  end

  it "is able to generate expiring token" do
    user = FactoryBot.create(:user)
    tokenizer = Clearance::Tokenizer.new(user)

    Timecop.freeze do
      token = tokenizer.generate(user.id, expires_in: 5.minutes)

      Timecop.travel((5.minutes - 1.second).from_now) do
        expect(tokenizer.valid?(token)).to be_truthy
      end

      Timecop.travel(5.minutes.from_now) do
        expect(tokenizer.valid?(token)).to be_falsey
      end
    end
  end

  describe "#valid?" do
    it "returns nil when given invalid token" do
      user = FactoryBot.create(:user)
      tokenizer = Clearance::Tokenizer.new(user)

      expect(tokenizer.valid?("invalid token")).to be_falsey
    end
  end
end
