module Clearance
  module PasswordStrategies
    # The Clearance::PasswordStrategies::Fake module is meant to be used in test suites.
    # It stores passwords as plain text so your test suite doesn't pay the time cost
    # of any hashing algorithm.
    #
    # Use the fake in your test suite by requiring Clearance's testing helpers:
    #
    #     require 'clearance/testing'
    #
    # The usual places you'd require it are:
    #
    #     spec/support/clearance.rb
    #     features/support/clearance.rb
    module Fake
      extend ActiveSupport::Concern

      def authenticated?(password)
        encrypted_password == password
      end

      def password=(new_password)
        @password = new_password
        if new_password.present?
          self.encrypted_password = encrypt(password)
        end
      end

      def encrypt(password)
        password
      end
    end
  end
end
