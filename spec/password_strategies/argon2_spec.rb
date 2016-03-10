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
      stub_argon2_cost(t_cost: 4, m_cost: 16)
      model_instance = fake_model_with_argon2_strategy

      allow(Rails).to receive(:env).
        and_return(ActiveSupport::StringInquirer.new("production"))

      model_instance.password = password

      expect(model_instance.encrypted_password).to eq('proper cost')
    end

    it "encrypts with Argon2 using minimum cost in test environment" do
      stub_argon2_cost(t_cost: 1, m_cost: 4)
      model_instance = fake_model_with_argon2_strategy

      model_instance.password = password

      expect(model_instance.encrypted_password).to eq('proper cost')
    end

    def stub_argon2_password
      allow_any_instance_of(Argon2::Password).to receive(:create).and_return(encrypted_password)
    end

    def stub_argon2_cost(t_cost:, m_cost:)
      allow_any_instance_of(Argon2::Password).to receive(:create).with(
        password,
        t_cost: t_cost,
        m_cost: m_cost
      ).and_return('proper cost')
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
