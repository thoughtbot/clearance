require 'spec_helper'

describe Clearance::PasswordStrategies::PKCS5 do

  subject do
    fake_model_with_password_strategy(Clearance::PasswordStrategies::PKCS5)
  end

  describe '#password=' do

    context 'when the password is set' do
      let(:salt) { 'salt' }
      let(:password) { 'password' }

      before do
        subject.salt = salt
        subject.password = password
      end

      it 'encrypts the password using PKCS5' do
        encrypted = Base64.decode64(subject.encrypted_password)
        salt = Base64.decode64(subject.salt)
        decode_cipher = OpenSSL::PKCS5.pbkdf2_hmac_sha1(password, salt, 1, 16)

        expect(decode_cipher).to eq encrypted
      end
    end

    context 'when the salt is not set' do
      before do
        subject.salt = nil
        subject.password = 'whatever'
      end

      it 'should initialize the salt' do
        expect(subject.salt).not_to be_nil
      end

      it 'should store the salt in plain-text' do
        expect(subject.salt.encoding.name).to eq("UTF-8")
      end
    end
  end
end
