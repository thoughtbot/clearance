require 'spec_helper'

describe Clearance::User do
  subject do
    class UniquenessValidator < ActiveModel::Validator
      def validate(record)
      end
    end

    Class.new do
      include ActiveModel::Validations

      validates_with UniquenessValidator

      def self.before_validation(*args); end
      def self.before_create(*args); end

      include Clearance::User
    end.new
  end

  describe 'when Clearance.configuration.password_strategy is set' do
    let(:mock_password_strategy) { Module.new }

    before { Clearance.configuration.password_strategy = mock_password_strategy }

    it 'includes the value it is set to' do
      subject.should be_kind_of(mock_password_strategy)
    end
  end

  describe 'when Clearance.configuration.password_strategy is not set' do
    before { Clearance.configuration.password_strategy = nil }

    it 'includes Clearance::PasswordStrategies::BCrypt' do
      subject.should be_kind_of(Clearance::PasswordStrategies::BCrypt)
    end
  end
end
