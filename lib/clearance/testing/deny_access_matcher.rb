module Clearance
  module Testing
    module Matchers
      def deny_access(opts = {})
        DenyAccessMatcher.new(self, opts)
      end

      class DenyAccessMatcher
        attr_reader :failure_message, :failure_message_when_negated

        def initialize(context, opts)
          @context = context
          @flash = opts[:flash]
          @url = opts[:redirect]

          @failure_message = ''
          @failure_message_when_negated = ''
        end

        def description
          'deny access'
        end

        def matches?(controller)
          @controller = controller
          sets_the_flash? && redirects_to_url?
        end

        def failure_message_for_should
          failure_message
        end

        def failure_message_for_should_not
          failure_message_when_negated
        end

        private

        def denied_access_url
          if @controller.signed_in?
            '/'
          else
            @controller.sign_in_url
          end
        end

        def flash_notice
          @controller.flash[:notice]
        end

        def flash_notice_value
          if flash_notice.respond_to?(:values)
            flash_notice.values.first
          else
            flash_notice
          end
        end

        def redirects_to_url?
          @url ||= denied_access_url

          begin
            @context.send(:assert_redirected_to, @url)
            @failure_message_when_negated <<
              "Didn't expect to redirect to #{@url}."
            true
          rescue MiniTest::Assertion, ::Test::Unit::AssertionFailedError
            @failure_message << "Expected to redirect to #{@url} but did not."
            false
          end
        end

        def sets_the_flash?
          if @flash.blank?
            true
          else
            if flash_notice_value == @flash
              @failure_message_when_negated <<
                "Didn't expect to set the flash to #{@flash}"
              true
            else
              @failure_message << "Expected the flash to be set to #{@flash} "\
                "but was #{flash_notice_value}"
              false
            end
          end
        end
      end
    end
  end
end
