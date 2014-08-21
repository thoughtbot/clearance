require 'spec_helper'

describe Clearance::PasswordStrategies::SHA1 do
  subject do
    fake_model_with_password_strategy(Clearance::PasswordStrategies::SHA1)
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
        expect(subject.salt).to eq salt
      end

      it 'encrypts the password using SHA1 and the existing salt' do
        expected = Digest::SHA1.hexdigest("--#{salt}--#{password}--")
        expect(subject.encrypted_password).to eq expected
      end
    end

    context "when the password is not set" do
      before do
        subject.salt     = nil
        subject.password = ""
      end

      it "initializes the salt" do
        expect(subject.salt).not_to be_nil
      end

      it "doesn't encrpt the password" do
        expect(subject.encrypted_password).to be_nil
      end
    end
  end
end
