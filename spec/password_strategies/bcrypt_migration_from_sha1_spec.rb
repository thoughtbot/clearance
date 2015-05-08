require "spec_helper"
include FakeModelWithPasswordStrategy

describe Clearance::PasswordStrategies::BCryptMigrationFromSHA1 do
  around do |example|
    silence_warnings do
      example.run
    end
  end

  describe "#password=" do
    it "encrypts the password into a BCrypt-encrypted encrypted_password" do
      stub_bcrypt_password

      expect(model_instance.encrypted_password).to eq encrypted_password
    end

    it "encrypts with BCrypt" do
      stub_bcrypt_password

      expect(BCrypt::Password).to have_received(:create).
        with(password, anything)
    end

    it "sets the pasword on the subject" do
      stub_bcrypt_password

      expect(model_instance.password).to be_present
    end

    def stub_bcrypt_password
      model_instance.salt = salt
      digestable = "--#{salt}--#{password}--"
      model_instance.encrypted_password = Digest::SHA1.hexdigest(digestable)
      allow(BCrypt::Password).to receive(:create).and_return(encrypted_password)
      model_instance.password = password
    end

    def encrypted_password
      @encrypted_password ||= double("encrypted password")
    end
  end

  describe "#authenticated?" do
    context "with a SHA1-encrypted password" do
      it "is authenticated" do
        model_instance.salt = salt
        model_instance.encrypted_password = sha1_hash
        allow(model_instance).to receive(:save)

        expect(model_instance).to be_authenticated(password)
      end

      it "changes the hash into a BCrypt-encrypted one" do
        model_instance.salt = salt
        model_instance.encrypted_password = sha1_hash
        allow(model_instance).to receive(:save)

        model_instance.authenticated? password

        expect(model_instance.encrypted_password).not_to eq sha1_hash
      end

      it "does not raise a BCrypt error for invalid passwords" do
        model_instance.salt = salt
        model_instance.encrypted_password = sha1_hash

        expect do
          model_instance.authenticated? "bad" + password
        end.not_to raise_error
      end

      it "saves the subject to database" do
        model_instance.salt = salt
        model_instance.encrypted_password = sha1_hash
        allow(model_instance).to receive(:save)

        model_instance.authenticated? password

        expect(model_instance).to have_received(:save)
      end

      def sha1_hash
        Digest::SHA1.hexdigest("--#{salt}--#{password}--")
      end
    end

    context "with a BCrypt-encrypted password" do
      it "is authenticated" do
        model_instance.encrypted_password = bcrypt_hash

        expect(model_instance).to be_authenticated(password)
      end

      it "does not change the hash" do
        model_instance.encrypted_password = bcrypt_hash

        model_instance.authenticated? password

        expect(model_instance.encrypted_password.to_s).to eq bcrypt_hash.to_s
      end

      def bcrypt_hash
        @bcrypt_hash ||= ::BCrypt::Password.create(password)
      end
    end
  end

  def model_instance
    @model_instance ||= fake_model_with_password_strategy(
      Clearance::PasswordStrategies::BCryptMigrationFromSHA1
    )
  end

  def salt
    "salt"
  end

  def password
    "password"
  end
end
