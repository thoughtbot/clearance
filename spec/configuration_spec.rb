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
      expect(Clearance.configuration.secure_cookie).to eq true
    end
  end

  context 'when secure_cookie is not specified' do
    before do
      Clearance.configure do |config|
      end
    end

    it 'defaults to false' do
      expect(Clearance.configuration.secure_cookie).to eq false
    end
  end

  context 'when no redirect URL specified' do
    it 'returns "/" as redirect URL' do
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

    it 'returns new redirect URL' do
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

    it 'returns the stack with added guards' do
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

  describe '#allow_sign_up?' do
    context 'when allow_sign_up is configured to false' do
      it 'returns false' do
        Clearance.configure { |config| config.allow_sign_up = false }
        expect(Clearance.configuration.allow_sign_up?).to eq false
      end
    end

    context 'when allow_sign_up has not been configured' do
      it 'returns true' do
        expect(Clearance.configuration.allow_sign_up?).to eq true
      end
    end
  end

  describe '#user_actions' do
    context 'when allow_sign_up is configured to false' do
      it 'returns empty array' do
        Clearance.configure { |config| config.allow_sign_up = false }
        expect(Clearance.configuration.user_actions).to eq []
      end
    end

    context 'when sign_up has not been configured' do
      it 'returns create' do
        expect(Clearance.configuration.user_actions).to eq [:create]
      end
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

  describe "#reload_user_model" do
    it "returns the user model class if one has already been configured" do
      ConfiguredUser = Class.new
      Clearance.configure { |config| config.user_model = ConfiguredUser }

      expect(Clearance.configuration.reload_user_model).to eq ConfiguredUser
    end

    it "returns nil if the user_model has not been configured" do
      Clearance.configuration = Clearance::Configuration.new

      expect(Clearance.configuration.reload_user_model).to be_nil
    end
  end
end
