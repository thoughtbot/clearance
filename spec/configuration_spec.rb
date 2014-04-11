require 'spec_helper'

describe Clearance::Configuration do
  after { restore_default_config }

  describe '#user_model' do
    it 'defaults to User' do
      expect(Clearance.configuration.user_model).to eq ::User
    end

    it 'uses the specified class when configured' do
      MyUser = Class.new
      Clearance.configure { |config| config.user_model = MyUser }
      expect(Clearance.configuration.user_model).to eq ::MyUser
    end
  end

  describe '#secure_cookie' do
    it 'defaults to false' do
      expect(Clearance.configuration.secure_cookie).to be false
    end

    it 'is true when configured' do
      Clearance.configure { |config| config.secure_cookie = true }
      expect(Clearance.configuration.secure_cookie).to be true
    end
  end

  describe '#redirect_url' do
    it 'defaults to "/"' do
      expect(Clearance::Configuration.new.redirect_url).to eq '/'
    end

    it 'can be configured' do
      redirect_url = '/admin'
      Clearance.configure { |config| config.redirect_url = redirect_url }
      expect(Clearance.configuration.redirect_url).to eq redirect_url
    end
  end

  describe '#sign_in_guards' do
    it 'returns the stack with added guards' do
      DummyGuard = Class.new
      Clearance.configure { |config| config.sign_in_guards = [DummyGuard] }
      expect(Clearance.configuration.sign_in_guards).to eq [DummyGuard]
    end
  end

  describe '#cookie_domain' do
    it 'returns configured value' do
      domain = 'example.com'
      Clearance.configure { |config| config.cookie_domain = domain }
      expect(Clearance.configuration.cookie_domain).to eq domain
    end
  end

  describe '#cookie_path' do
    it 'returns configured value' do
      path = '/user'
      Clearance.configure { |config| config.cookie_path = path }
      expect(Clearance.configuration.cookie_path).to eq path
    end
  end

  describe '#allow_sign_up?' do
    it 'defaults to true' do
      expect(Clearance.configuration.allow_sign_up?).to be true
    end

    it 'can be configured to false' do
      Clearance.configure { |config| config.allow_sign_up = false }
      expect(Clearance.configuration.allow_sign_up?).to be false
    end
  end

  describe '#user_actions' do
    it 'defaults to [:create]' do
      expect(Clearance.configuration.user_actions).to eq [:create]
    end

    it 'is empty when sign up is disabled' do
      Clearance.configure { |config| config.allow_sign_up = false }
      expect(Clearance.configuration.user_actions).to be_empty
    end
  end

  describe '#user_id_parameter' do
    it 'returns the parameter key to use based on the user_model' do
      CustomUser = Class.new(ActiveRecord::Base)
      Clearance.configure { |config| config.user_model = CustomUser }
      expect(Clearance.configuration.user_id_parameter).to eq :custom_user_id
    end
  end

  describe '#routes_enabled?' do
    it 'is true by default' do
      expect(Clearance.configuration.routes_enabled?).to be true
    end

    it 'is false when routes are set to false' do
      Clearance.configure { |config| config.routes = false }
      expect(Clearance.configuration.routes_enabled?).to be false
    end
  end
end
