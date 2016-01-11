require "spec_helper"

describe Clearance::Testing::ControllerHelpers do
  class TestClass
    include Clearance::Testing::ControllerHelpers

    def initialize
      @request = Class.new do
        def env
          { clearance: Clearance::Session.new({}) }
        end
      end.new
    end
  end

  describe "#sign_in" do
    it "creates an instance of the clearance user model with FactoryGirl" do
      MyUserModel = Class.new
      allow(FactoryGirl).to receive(:create)
      allow(Clearance.configuration).to receive(:user_model).
        and_return(MyUserModel)

      TestClass.new.sign_in

      expect(FactoryGirl).to have_received(:create).with(:my_user_model)
    end
  end

  describe "#sign_in_as" do
    it "returns the user if signed in successfully" do
      user = build(:user)

      returned_user = TestClass.new.sign_in_as user

      expect(returned_user).to eq user
    end
  end
end
