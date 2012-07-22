require 'spec_helper'

describe Clearance::PasswordStrategies::SHA1 do
  subject do
    Class.new do
      attr_accessor :salt, :encrypted_password
      include Clearance::PasswordStrategies::SHA1

      def generate_random_code; "code"; end
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

      it 'encrypts the password using SHA1 and the existing salt' do
        expected = Digest::SHA1.hexdigest("--#{salt}--#{password}--")
        subject.encrypted_password.should == expected
      end
    end

    context "when the password is not set" do
      before do
        subject.salt     = nil
        subject.password = ""
      end

      it "initializes the salt" do
        subject.salt.should_not be_nil
      end

      it "doesn't encrpt the password" do
        subject.encrypted_password.should be_nil
      end
    end
  end
end
