require "spec_helper"
include FakeModelWithPasswordStrategy

describe Clearance::PasswordStrategies::Blowfish do
  around do |example|
    silence_warnings do
      example.run
    end
  end

  describe "#password=" do
    context "when the password is set" do
      it "does not initialize the salt" do
        model_instance = fake_model_with_blowfish_strategy
        model_instance.salt = salt
        model_instance.password = password

        expect(model_instance.salt).to eq salt
      end

      it "encrypts the password using Blowfish and the existing salt" do
        model_instance = fake_model_with_blowfish_strategy
        model_instance.salt = salt
        model_instance.salt = salt
        model_instance.password = password
        cipher = OpenSSL::Cipher::Cipher.new("bf-cbc").encrypt
        cipher.key = Digest::SHA256.digest(salt)
        expected = cipher.update("--#{salt}--#{password}--") << cipher.final

        encrypted_password = Base64.decode64(model_instance.encrypted_password)

        expect(encrypted_password).to eq expected
      end
    end

    context "when the salt is not set" do
      it "should initialize the salt" do
        model_instance = fake_model_with_blowfish_strategy
        model_instance.salt = salt
        model_instance.salt = nil
        model_instance.password = password

        expect(model_instance.salt).not_to be_nil
      end
    end
  end

  def fake_model_with_blowfish_strategy
    @model_instance ||= fake_model_with_password_strategy(
      Clearance::PasswordStrategies::Blowfish
    )
  end

  def salt
    "salt"
  end

  def password
    "password"
  end
end
