require 'spec_helper'

describe Clearance::Configuration do
  after { restore_default_config }

  describe 'when no user_model_name is specified' do
    before do
      Clearance.configure do |config|
      end
    end

    it 'defaults to User' do
      expect(Clearance.configuration.user_model).to eq ::User
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
      expect(Clearance.configuration.user_model).to eq ::MyUser
    end
  end

  describe 'when secure_cookie is set to true' do
    before do
      Clearance.configure do |config|
        config.secure_cookie = true
      end
    end

    after do
      Clearance.configure do |config|
        config.secure_cookie = false
      end
    end

    it 'returns true' do
      expect(Clearance.configuration.secure_cookie).to be_true
    end
  end

  describe 'when secure_cookie is not specified' do
    before do
      Clearance.configure do |config|
      end
    end

    it 'defaults to false' do
      expect(Clearance.configuration.secure_cookie).to be_false
    end
  end

  describe 'when no redirect URL specified' do
    it 'should return "/" as redirect URL' do
      expect(Clearance::Configuration.new.redirect_url).to eq '/'
    end
  end

  describe 'when redirect URL is specified' do
    let(:new_redirect_url) { '/admin' }

    before do
      Clearance.configure do |config|
        config.redirect_url = new_redirect_url
      end
    end

    after do
      Clearance.configure do |config|
        config.redirect_url = '/'
      end
    end

    it 'should return new redirect URL' do
      expect(Clearance.configuration.redirect_url).to eq new_redirect_url
    end
  end

  describe 'when specifying sign in guards' do
    DummyGuard = Class.new

    before do
      Clearance.configure do |config|
        config.sign_in_guards = [DummyGuard]
      end
    end

    after do
      Clearance.configure do |config|
        config.sign_in_guards = []
      end
    end

    it 'should return the stack with added guards' do
      expect(Clearance.configuration.sign_in_guards).to eq [DummyGuard]
    end
  end
end
