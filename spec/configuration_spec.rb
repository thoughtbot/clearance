require 'spec_helper'

describe Clearance::Configuration do
  after { restore_default_config }

  context 'when no user_model_name is specified' do
    before do
      Clearance.configure do |config|
      end
    end

    it 'defaults to User' do
      expect(Clearance.configuration.user_model).to eq ::User
    end
  end

  context 'when a custom user_model_name is specified' do
    before do
      MyUser = Class.new

      Clearance.configure do |config|
        config.user_model = MyUser
      end
    end

    it 'is used instead of User' do
      expect(Clearance.configuration.user_model).to eq ::MyUser
    end
  end

  context 'when secure_cookie is set to true' do
    before do
      Clearance.configure do |config|
        config.secure_cookie = true
      end
    end

    it 'returns true' do
      expect(Clearance.configuration.secure_cookie).to be_true
    end
  end

  context 'when secure_cookie is not specified' do
    before do
      Clearance.configure do |config|
      end
    end

    it 'defaults to false' do
      expect(Clearance.configuration.secure_cookie).to be_false
    end
  end

  context 'when no redirect URL specified' do
    it 'should return "/" as redirect URL' do
      expect(Clearance::Configuration.new.redirect_url).to eq '/'
    end
  end

  context 'when redirect URL is specified' do
    let(:new_redirect_url) { '/admin' }

    before do
      Clearance.configure do |config|
        config.redirect_url = new_redirect_url
      end
    end

    it 'should return new redirect URL' do
      expect(Clearance.configuration.redirect_url).to eq new_redirect_url
    end
  end

  context 'when specifying sign in guards' do
    DummyGuard = Class.new

    before do
      Clearance.configure do |config|
        config.sign_in_guards = [DummyGuard]
      end
    end

    it 'should return the stack with added guards' do
      expect(Clearance.configuration.sign_in_guards).to eq [DummyGuard]
    end
  end

  context 'when cookie domain is specified' do
    let(:domain) { '.example.com' }

    before do
      Clearance.configure do |config|
        config.cookie_domain = domain
      end
    end

    it 'returns configured value' do
      expect(Clearance.configuration.cookie_domain).to eq domain
    end
  end

  context 'when cookie path is specified' do
    let(:path) { '/user' }

    before do
      Clearance.configure do |config|
        config.cookie_path = path
      end
    end

    it 'returns configured value' do
      expect(Clearance.configuration.cookie_path).to eq path
    end
  end
end
