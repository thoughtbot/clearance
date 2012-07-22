require 'clearance'

Clearance.configure do |config|
end

class ApplicationController < ActionController::Base
  include Clearance::Authentication
end

class User < ActiveRecord::Base
  include Clearance::User
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
