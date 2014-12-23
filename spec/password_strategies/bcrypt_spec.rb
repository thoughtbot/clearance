require "spec_helper"
include FakeModelWithPasswordStrategy

describe Clearance::PasswordStrategies::BCrypt do
  describe "#password=" do
    it "encrypts the password into encrypted_password" do
      stub_bcrypt_password
      model_instance = fake_model_with_bcrypt_strategy

      model_instance.password = password

      expect(model_instance.encrypted_password).to eq encrypted_password
    end

    it "encrypts with BCrypt using default cost in non test environments" do
      stub_bcrypt_password
      model_instance = fake_model_with_bcrypt_strategy
      allow(Rails).to receive(:env).
        and_return(ActiveSupport::StringInquirer.new("production"))

      model_instance.password = password

      expect(BCrypt::Password).to have_received(:create).with(
        password,
        cost: ::BCrypt::Engine::DEFAULT_COST
      )
    end

    it "encrypts with BCrypt using minimum cost in test environment" do
      stub_bcrypt_password
      model_instance = fake_model_with_bcrypt_strategy

      model_instance.password = password

      expect(BCrypt::Password).to have_received(:create).with(
        password,
        cost: ::BCrypt::Engine::MIN_COST
      )
    end

    def stub_bcrypt_password
      allow(BCrypt::Password).to receive(:create).and_return(encrypted_password)
    end

    def encrypted_password
      @encrypted_password ||= double("encrypted password")
    end
  end

  describe "#authenticated?" do
    context "given a password" do
      it "is authenticated with BCrypt" do
        model_instance = fake_model_with_bcrypt_strategy

        model_instance.password = password

        expect(model_instance).to be_authenticated(password)
      end
    end

    context "given no password" do
      it "is not authenticated" do
        model_instance = fake_model_with_bcrypt_strategy

        password = nil

        expect(model_instance).not_to be_authenticated(password)
      end
    end
  end

  def fake_model_with_bcrypt_strategy
    @model_instance ||= fake_model_with_password_strategy(
      Clearance::PasswordStrategies::BCrypt
    )
  end

  def password
    "password"
  end
end
