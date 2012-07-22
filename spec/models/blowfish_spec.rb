require 'spec_helper'

describe Clearance::PasswordStrategies::Blowfish do
  subject do
    Class.new do
      attr_accessor :salt, :encrypted_password
      include Clearance::PasswordStrategies::Blowfish

      def generate_random_code; 'code'; end
    end.new
  end

  describe '#password=' do
    context 'when the password is set' do
      let(:salt) { 'salt' }
      let(:password) { 'password' }

      before do
        subject.salt = salt
        subject.password = password
      end

      it 'does not initialize the salt' do
        subject.salt.should == salt
      end

      it 'encrypts the password using Blowfish and the existing salt' do
        cipher = OpenSSL::Cipher::Cipher.new('bf-cbc').encrypt
        cipher.key = Digest::SHA256.digest(salt)
        expected = cipher.update("--#{salt}--#{password}--") << cipher.final
        subject.encrypted_password.should == expected
      end
    end

    context 'when the salt is not set' do
      before do
        subject.salt = nil
        subject.password = 'whatever'
      end

      it 'should initialize the salt' do
        subject.salt.should_not be_nil
      end
    end
  end
end
