require 'spec_helper'

describe Clearance::PasswordStrategies::BCrypt do
  subject do
    fake_model_with_password_strategy(Clearance::PasswordStrategies::BCrypt)
  end

  describe '#password=' do
    let(:password) { 'password' }
    let(:encrypted_password) { stub('encrypted password') }

    before do
      BCrypt::Password.stubs :create => encrypted_password
      subject.password = password
    end

    it 'encrypts the password into encrypted_password' do
      subject.encrypted_password.should == encrypted_password
    end

    it 'encrypts with BCrypt' do
      BCrypt::Password.should have_received(:create).with(password)
    end
  end

  describe '#authenticated?' do
    let(:password) { 'password' }

    before do
      subject.password = password
    end

    it 'is authenticated with BCrypt' do
      subject.should be_authenticated(password)
    end
  end
end
