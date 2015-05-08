require "spec_helper"
include FakeModelWithPasswordStrategy

describe Clearance::PasswordStrategies::SHA1 do
  around do |example|
    silence_warnings do
      example.run
    end
  end

  describe "#password=" do
    context "when the salt is set" do
      it "does not initialize the salt when assigned" do
        model_instance = fake_model_with_sha1_strategy

        model_instance.salt = salt

        expect(model_instance.salt).to eq salt
      end

      it "encrypts the password using SHA1 and the existing salt" do
        model_instance = fake_model_with_sha1_strategy
        model_instance.salt = salt
        model_instance.password = password

        expected = Digest::SHA1.hexdigest("--#{salt}--#{password}--")

        expect(model_instance.encrypted_password).to eq expected
      end
    end

    context "when the salt is set" do
      it "generates the salt" do
        model_instance = fake_model_with_sha1_strategy
        model_instance.password = ""

        expect(model_instance.salt).not_to be_nil
      end

      it "doesn't encrypt the password" do
        model_instance = fake_model_with_sha1_strategy

        expect(model_instance.encrypted_password).to be_nil
      end
    end
  end

  def fake_model_with_sha1_strategy
    fake_model_with_password_strategy(Clearance::PasswordStrategies::SHA1)
  end

  def salt
    "salt"
  end

  def password
    "password"
  end
end
