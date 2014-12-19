require 'spec_helper'

describe Clearance::PasswordStrategies::BCryptMigrationFromSHA1 do
  subject do
    fake_model_with_password_strategy(
      Clearance::PasswordStrategies::BCryptMigrationFromSHA1
    )
  end

  describe '#password=' do
    let(:salt) { 'salt' }
    let(:password) { 'password' }
    let(:encrypted_password) { double("encrypted password") }

    before do
      subject.salt = salt
      digestable = "--#{salt}--#{password}--"
      subject.encrypted_password = Digest::SHA1.hexdigest(digestable)
      allow(BCrypt::Password).to receive(:create).and_return(encrypted_password)
      subject.password = password
    end

    it 'encrypts the password into a BCrypt-encrypted encrypted_password' do
      expect(subject.encrypted_password).to eq encrypted_password
    end

    it 'encrypts with BCrypt' do
      have_received_password = have_received(:create).with(password, anything)
      expect(BCrypt::Password).to have_received_password
    end

    it 'sets the pasword on the subject' do
      expect(subject.password).to be_present
    end
  end

  describe '#authenticated?' do
    let(:password) { 'password' }
    let(:salt) { 'salt' }
    let(:sha1_hash) { Digest::SHA1.hexdigest("--#{salt}--#{password}--") }

    context 'with a SHA1-encrypted password' do
      before do
        subject.salt = salt
        subject.encrypted_password = sha1_hash
        allow(subject).to receive(:save).and_return(true)
      end

      it 'is authenticated' do
        expect(subject).to be_authenticated(password)
      end

      it 'changes the hash into a BCrypt-encrypted one' do
        subject.authenticated? password
        expect(subject.encrypted_password).not_to eq sha1_hash
      end

      it 'does not raise a BCrypt error for invalid passwords' do
        expect { subject.authenticated? 'bad' + password }.not_to raise_error
      end

      it 'saves the subject to database' do
        subject.authenticated? password
        expect(subject).to have_received(:save)
      end
    end

    context 'with a BCrypt-encrypted password' do
      let(:bcrypt_hash) { ::BCrypt::Password.create(password) }

      before do
        subject.encrypted_password = bcrypt_hash
      end

      it 'is authenticated' do
        expect(subject).to be_authenticated(password)
      end

      it 'does not change the hash' do
        subject.authenticated? password
        expect(subject.encrypted_password.to_s).to eq bcrypt_hash.to_s
      end
    end
  end
end
