require "spec_helper"

MyController = Class.new
DummyGuard = Class.new
Account = Class.new(ActiveRecord::Base)
CustomUser = Class.new(ActiveRecord::Base)
ConfiguredUser = Class.new
MyUser = Class.new

describe Clearance::Configuration do
  let(:config) { Clearance.configuration }

  context "when no user_model_name is specified" do
    it "defaults to User" do
      expect(Clearance.configuration.user_model).to eq ::User
    end
  end

  context "when a custom user_model_name is specified" do
    it "is used instead of User" do
      Clearance.configure { |config| config.user_model = MyUser }

      expect(Clearance.configuration.user_model).to eq ::MyUser
    end

    it "can be specified as a string to avoid triggering autoloading" do
      Clearance.configure { |config| config.user_model = "MyUser" }

      expect(Clearance.configuration.user_model).to eq ::MyUser
    end
  end

  context "when no parent_controller is specified" do
    it "defaults to ApplicationController" do
      expect(config.parent_controller).to eq ::ApplicationController
    end
  end

  context "when a custom parent_controller is specified" do
    it "is used instead of ApplicationController" do
      Clearance.configure { |config| config.parent_controller = MyController }

      expect(config.parent_controller).to eq ::MyController
    end
  end

  context "when secure_cookie is set to true" do
    it "returns true" do
      Clearance.configure { |config| config.secure_cookie = true }
      expect(Clearance.configuration.secure_cookie).to eq true
    end
  end

  context "when secure_cookie is not specified" do
    it "defaults to false" do
      expect(Clearance.configuration.secure_cookie).to eq false
    end
  end

  context "when signed_cookie is set to true" do
    it "returns true" do
      Clearance.configure { |config| config.signed_cookie = true }
      expect(Clearance.configuration.signed_cookie).to eq true
    end
  end

  context "when signed_cookie is not specified" do
    it "defaults to false" do
      expect(Clearance.configuration.signed_cookie).to eq false
    end
  end

  context "when signed_cookie is set to :migrate" do
    it "returns :migrate" do
      Clearance.configure { |config| config.signed_cookie = :migrate }
      expect(Clearance.configuration.signed_cookie).to eq :migrate
    end
  end

  context "when signed_cookie is set to an unexpected value" do
    it "returns :migrate" do
      expect {
        Clearance.configure { |config| config.signed_cookie = "unknown" }
      }.to raise_exception(RuntimeError)
    end
  end

  context "when no redirect URL specified" do
    it 'returns "/" as redirect URL' do
      expect(Clearance::Configuration.new.redirect_url).to eq "/"
    end
  end

  context "when redirect URL is specified" do
    it "returns new redirect URL" do
      new_redirect_url = "/admin"
      Clearance.configure { |config| config.redirect_url = new_redirect_url }

      expect(Clearance.configuration.redirect_url).to eq new_redirect_url
    end
  end

  context "when no url_after_destroy value specified" do
    it "returns nil as the default" do
      expect(Clearance::Configuration.new.url_after_destroy).to be_nil
    end
  end

  context "when url_after_destroy value is specified" do
    it "returns the url_after_destroy value" do
      Clearance.configure { |config| config.url_after_destroy = "/redirect" }

      expect(Clearance.configuration.url_after_destroy).to eq "/redirect"
    end
  end

  context "when no url_after_denied_access_when_signed_out value specified" do
    it "returns nil as the default" do
      expect(Clearance::Configuration.new.url_after_denied_access_when_signed_out).to be_nil
    end
  end

  context "when url_after_denied_access_when_signed_out value is specified" do
    it "returns the url_after_denied_access_when_signed_out value" do
      Clearance.configure { |config| config.url_after_denied_access_when_signed_out = "/redirect" }

      expect(Clearance.configuration.url_after_denied_access_when_signed_out).to eq "/redirect"
    end
  end

  context "when specifying sign in guards" do
    it "returns the stack with added guards" do
      Clearance.configure { |config| config.sign_in_guards = [DummyGuard] }

      expect(Clearance.configuration.sign_in_guards).to eq [DummyGuard]
    end
  end

  context "when cookie domain is specified" do
    it "returns configured value" do
      domain = ".example.com"
      Clearance.configure { |config| config.cookie_domain = domain }

      expect(Clearance.configuration.cookie_domain).to eq domain
    end
  end

  context "when cookie path is specified" do
    it "returns configured value" do
      path = "/user"
      Clearance.configure { |config| config.cookie_path = path }

      expect(Clearance.configuration.cookie_path).to eq path
    end
  end

  describe "#allow_sign_up?" do
    context "when allow_sign_up is configured to false" do
      it "returns false" do
        Clearance.configure { |config| config.allow_sign_up = false }
        expect(Clearance.configuration.allow_sign_up?).to eq false
      end
    end

    context "when allow_sign_up has not been configured" do
      it "returns true" do
        expect(Clearance.configuration.allow_sign_up?).to eq true
      end
    end
  end

  describe "#allow_password_reset?" do
    context "when allow_password_reset is configured to false" do
      it "returns false" do
        Clearance.configure { |config| config.allow_password_reset = false }
        expect(Clearance.configuration.allow_password_reset?).to eq false
      end
    end

    context "when allow_sign_up has not been configured" do
      it "returns true" do
        expect(Clearance.configuration.allow_password_reset?).to eq true
      end
    end
  end

  describe "#user_actions" do
    context "when allow_sign_up is configured to false" do
      it "returns empty array" do
        Clearance.configure { |config| config.allow_sign_up = false }
        expect(Clearance.configuration.user_actions).to eq []
      end
    end

    context "when sign_up has not been configured" do
      it "returns create" do
        expect(Clearance.configuration.user_actions).to eq [:create]
      end
    end
  end

  describe "#user_parameter" do
    context "when user_parameter is configured" do
      it "returns the configured parameter" do
        Clearance.configure { |config| config.user_parameter = :custom_param }
        expect(Clearance.configuration.user_parameter).to eq :custom_param
      end
    end

    it "returns the parameter key to use based on the user_model by default" do
      Clearance.configure { |config| config.user_model = Account }

      expect(Clearance.configuration.user_parameter).to eq :account
    end
  end

  describe "#user_id_parameter" do
    it "returns the parameter key to use based on the user_model" do
      Clearance.configure { |config| config.user_model = CustomUser }

      expect(Clearance.configuration.user_id_parameter).to eq :custom_user_id
    end
  end

  describe "#routes_enabled?" do
    it "is true by default" do
      expect(Clearance.configuration.routes_enabled?).to be true
    end

    it "is false when routes are set to false" do
      Clearance.configure { |config| config.routes = false }
      expect(Clearance.configuration.routes_enabled?).to be false
    end
  end

  describe "#reload_user_model" do
    it "returns the user model class if one has already been configured" do
      Clearance.configure { |config| config.user_model = ConfiguredUser }

      expect(Clearance.configuration.reload_user_model).to eq ConfiguredUser
    end

    it "returns nil if the user_model has not been configured" do
      Clearance.configuration = Clearance::Configuration.new

      expect(Clearance.configuration.reload_user_model).to be_nil
    end
  end

  describe "#rotate_csrf_on_sign_in?" do
    it "is true when `rotate_csrf_on_sign_in` is set to true" do
      Clearance.configure { |config| config.rotate_csrf_on_sign_in = true }

      expect(Clearance.configuration.rotate_csrf_on_sign_in?).to be true
    end

    it "is false when `rotate_csrf_on_sign_in` is set to false" do
      Clearance.configure { |config| config.rotate_csrf_on_sign_in = false }

      expect(Clearance.configuration.rotate_csrf_on_sign_in?).to be false
    end

    it "is false when `rotate_csrf_on_sign_in` is set to nil" do
      Clearance.configure { |config| config.rotate_csrf_on_sign_in = nil }

      expect(Clearance.configuration.rotate_csrf_on_sign_in?).to be false
    end
  end
end
