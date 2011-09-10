require 'spec_helper'

describe Clearance::PasswordStrategies::SHA1 do
  subject do
    Class.new do
      attr_accessor :salt, :password, :encrypted_password
      include Clearance::PasswordStrategies::SHA1

      def generate_random_code; "code"; end
    end.new
  end

  describe "#encrypt_password" do
    context "when the password is set" do
      let(:salt) { "salt" }
      let(:password) { "password" }

      before do
        subject.salt = salt
        subject.password = password
        subject.send(:encrypt_password)
      end

      it "should encrypt the password using SHA1 into encrypted_password" do
        expected = Digest::SHA1.hexdigest("--#{salt}--#{password}--")

        subject.encrypted_password.should == expected
      end
    end

    context "when the salt is not set" do
      before do
        subject.salt = nil

        subject.send(:encrypt_password)
      end

      it "should initialize the salt" do
        subject.salt.should_not be_nil
      end
    end
  end
end
