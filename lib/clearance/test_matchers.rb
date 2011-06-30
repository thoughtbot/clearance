module Clearance
  module Test
    module Matchers
      def deny_access(opts = {})
        if opts[:flash]
          should set_the_flash.to(opts[:flash])
        else
          should_not set_the_flash
        end

        redirect_to(Clearance.configuration.denied_access_url.call)
      end
    end

    module Helpers
      def sign_in_as(user)
        @controller.current_user = user
        return user
      end

      def sign_in
        sign_in_as Factory(:user)
      end

      def sign_out
        @controller.current_user = nil
      end
    end
  end
end

if defined?(Test::Unit::TestCase)
  Test::Unit::TestCase.extend  Clearance::Test::Matchers
  class Test::Unit::TestCase
    include Clearance::Test::Helpers
  end
end

if defined?(RSpec) && RSpec.respond_to?(:configure)
  RSpec.configure do |config|
    config.include Clearance::Test::Matchers
    config.include Clearance::Test::Helpers
  end
end
