require 'clearance'

Clearance.configure do |config|
  # need an empty block to initialize the configuration object
end

# NOTE: to run the entire suite with signed cookies
#       you can set the signed_cookie default to true
#       and run all specs.
#       However, to fake the actual signing process you
#       can monkey-patch ActionDispatch so signed cookies
#       behave like normal ones
#
# class ActionDispatch::Cookies::CookieJar
#   def signed; self; end
# end

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
