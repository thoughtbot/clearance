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
      Clearance::Configuration.new.root_path.should == '/'
    end
  end

  describe 'when root path is specified' do
    let(:desired_root_path){ '/admin/' }

    before do
      Clearance.configure do |config|
        config.root_path = desired_root_path
      end
    end

    after do
      Clearance.configure do |config|
        config.root_path = '/'
      end
    end

    it 'should return desired root path' do
      Clearance.configuration.root_path.should == desired_root_path
    end
  end
end
