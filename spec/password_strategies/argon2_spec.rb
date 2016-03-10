require "spec_helper"
include FakeModelWithPasswordStrategy

describe Clearance::PasswordStrategies::Argon2 do
  describe "#password=" do
    it "encrypts the password into encrypted_password" do
      stub_argon2_password

      model_instance = fake_model_with_argon2_strategy

      model_instance.password = password

      expect(model_instance.encrypted_password).to eq encrypted_password
    end

    it "encrypts with Argon2 using default cost in non test environments" do
      model_instance = fake_model_with_argon2_strategy

      allow(Rails).to receive(:env).
        and_return(ActiveSupport::StringInquirer.new("production"))

      expect(Argon2::Password).to receive(:new).with(t_cost: 2, m_cost: 16).
        and_return(Argon2::Password.new(t_cost: 2, m_cost: 16))

      model_instance.password = password
    end

    it "encrypts with Argon2 using minimum cost in test environment" do
      model_instance = fake_model_with_argon2_strategy

      expect(Argon2::Password).to receive(:new).with(t_cost: 1, m_cost: 4).
        and_return(Argon2::Password.new(t_cost: 1, m_cost: 4))

      model_instance.password = password
    end

    def stub_argon2_password
      allow_any_instance_of(Argon2::Password).to receive(:create).
        and_return(encrypted_password)
    end

    def encrypted_password
      @encrypted_password ||= double("encrypted password")
    end
  end

  describe "#authenticated?" do
    context "given a password" do
      it "is authenticated with Argon2" do
        model_instance = fake_model_with_argon2_strategy

        model_instance.password = password

        expect(model_instance).to be_authenticated(password)
      end
    end

    context "given no password" do
      it "is not authenticated" do
        model_instance = fake_model_with_argon2_strategy

        password = nil

        expect(model_instance).not_to be_authenticated(password)
      end
    end
  end

  def fake_model_with_argon2_strategy
    @model_instance ||= fake_model_with_password_strategy(
      Clearance::PasswordStrategies::Argon2
    )
  end

  def password
    "password"
  end
end
