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
    let(:encrypted_password) { stub('encrypted password') }

    before do
      subject.salt = salt
      subject.encrypted_password = Digest::SHA1.hexdigest("--#{salt}--#{password}--")
      BCrypt::Password.stubs :create => encrypted_password
      subject.password = password
    end

    it 'encrypts the password into a BCrypt-encrypted encrypted_password' do
      subject.encrypted_password.should == encrypted_password
    end

    it 'encrypts with BCrypt' do
      BCrypt::Password.should have_received(:create).with(password, anything)
    end

    it 'sets the pasword on the subject' do
      subject.password.should be_present
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
        subject.stubs :save => true
      end

      it 'is authenticated' do
        subject.should be_authenticated(password)
      end

      it 'changes the hash into a BCrypt-encrypted one' do
        subject.authenticated? password
        subject.encrypted_password.should_not == sha1_hash
      end

      it 'does not raise a BCrypt error for invalid passwords' do
        expect {
          subject.authenticated? 'bad' + password
        }.not_to raise_error
      end

      it 'saves the subject to database' do
        subject.authenticated? password
        subject.should have_received(:save)
      end
    end

    context 'with a BCrypt-encrypted password' do
      let(:bcrypt_hash) { ::BCrypt::Password.create(password) }

      before do
        subject.encrypted_password = bcrypt_hash
      end

      it 'is authenticated' do
        subject.should be_authenticated(password)
      end

      it 'does not change the hash' do
        subject.authenticated? password
        subject.encrypted_password.to_s.should == bcrypt_hash.to_s
      end
    end
  end
end
