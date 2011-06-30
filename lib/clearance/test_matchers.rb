module Clearance
  module Test
    module Matchers
      # Ensures a controller denied access.
      #
      # @example
      #   it { should deny_access  }
      #   it { should deny_access(:flash => "Denied access.")  }
      #   it { should deny_access(:redirect => sign_in_url)  }
      def deny_access(opts = {})
        DenyAccessMatcher.new(self, opts)
      end

      class DenyAccessMatcher
        attr_reader :failure_message, :negative_failure_message

        def initialize(context, opts)
          @context = context
          @flash   = opts[:flash]
          @url     = opts[:redirect]

          @failure_message          = ""
          @negative_failure_message = ""
        end

        def matches?(controller)
          @controller = controller
          sets_the_flash? && redirects_to_url?
        end

        def description
          "deny access"
        end

        private

        def sets_the_flash?
          if @flash.blank?
            true
          else
            if @controller.flash[:notice].try(:values).try(:first) == @flash
              @negative_failure_message << "Didn't expect to set the flash to #{@flash}"
              true
            else
              @failure_message << "Expected the flash to be set to #{@flash} but was #{@controller.flash[:notice].try(:values).try(:first)}"
              false
            end
          end
        end

        def redirects_to_url?
          @url ||= denied_access_url
          begin
            @context.send(:assert_redirected_to, @url)
              @negative_failure_message << "Didn't expect to redirect to #{@url}."
              true
          rescue
            @failure_message << "Expected to redirect to #{@url} but did not."
            false
          end
        end

        def denied_access_url
          if @controller.signed_in?
            '/'
          else
            @controller.sign_in_url
          end
        end
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
