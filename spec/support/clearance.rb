require 'clearance'

Clearance.configure do |config|
  # need an empty block to initialize the configuration object
end

class ApplicationController < ActionController::Base
  include Clearance::Controller
end

class User < ActiveRecord::Base
  include Clearance::User
end

class UserWithOptionalPassword < User
  private

  def password_optional?
    true
  end
end

module Clearance
  module Test
    module Redirects
      def redirect_to_url_after_create
        redirect_to(@controller.send(:url_after_create))
      end

      def redirect_to_url_after_update
        redirect_to(@controller.send(:url_after_update))
      end

      def redirect_to_url_after_destroy
        redirect_to(@controller.send(:url_after_destroy))
      end
    end
  end
end

RSpec.configure do |config|
  config.include Clearance::Test::Redirects
end
