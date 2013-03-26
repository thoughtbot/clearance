require 'spec_helper'

describe Clearance::Configuration do
  describe 'when no user_model_name is specified' do
    before do
      Clearance.configure do |config|
      end
    end

    it 'defaults to User' do
      Clearance.configuration.user_model.should == ::User
    end
  end

  describe 'when a custom user_model_name is specified' do
    before do
      MyUser = Class.new

      Clearance.configure do |config|
        config.user_model = MyUser
      end
    end

    after do
      Clearance.configure do |config|
        config.user_model = ::User
      end
    end

    it 'is used instead of User' do
      Clearance.configuration.user_model.should == ::MyUser
    end
  end

  describe 'when no root path specified' do
    it 'should return "/" as root path' do
      Clearance::Configuration.new.default_redirect_path.should == '/'
    end
  end

  describe 'when root path is specified' do
    let(:desired_default_path){ '/admin/' }

    before do
      Clearance.configure do |config|
        config.default_redirect_path = desired_default_path
      end
    end

    after do
      Clearance.configure do |config|
        config.default_redirect_path = '/'
      end
    end

    it 'should return desired root path' do
      Clearance.configuration.default_redirect_path.should == desired_default_path
    end
  end
end
