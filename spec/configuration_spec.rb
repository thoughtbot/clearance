require 'spec_helper'

describe Clearance::Configuration do
  describe "when no user_model_name is specified" do
    before do
      Clearance.configure do |config|
      end
    end

    it "defaults to User" do
      Clearance.configuration.user_model.should == ::User
    end
  end

  describe "when a custom user_model_name is specified" do
    before do
      Clearance.configure do |config|
        config.user_model_name = 'MyUser'
      end

      MyUser = Class.new
    end

    after do
      Clearance.configure do |config|
        config.user_model_name = '::User'
      end
    end

    it "is used instead of User" do
      Clearance.configuration.user_model.should == ::MyUser
    end
  end 
end