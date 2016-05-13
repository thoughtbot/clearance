module Clearance
  module Testing
    # Provides matchers to be used in your controller specs.
    # These are typically exposed to your controller specs by
    # requiring `clearance/rspec` or `clearance/test_unit` as
    # appropriate in your `rails_helper.rb` or `test_helper.rb`
    # files.
    module Matchers
      # The `deny_access` matcher is used to assert that a
      #   request is denied access by clearance.
      # @option opts [String] :flash The expected flash alert message. Defaults
      #   to nil, which means the flash will not be checked.
      # @option opts [String] :redirect The expected redirect url. Defaults to
      #   `'/'` if signed in or the `sign_in_url` if signed out.
      #
      #       class PostsController < ActionController::Base
      #         before_action :require_login
      #
      #         def index
      #           @posts = Post.all
      #         end
      #       end
      #
      #       describe PostsController do
      #         describe "#index" do
      #           it "denies access to users not signed in" do
      #             get :index
      #
      #             expect(controller).to deny_access
      #           end
      #         end
      #       end
      def deny_access(opts = {})
        DenyAccessMatcher.new(self, opts)
      end

      # @api private
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
          if clearance_session.signed_in?
            Clearance.configuration.redirect_url
          else
            @controller.sign_in_url
          end
        end

        def clearance_session
          @controller.request.env[:clearance]
        end

        def flash_alert
          @controller.flash[:alert]
        end

        def flash_alert_value
          flash_alert.values.first
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
          elsif flash_alert_value == @flash
            @failure_message_when_negated <<
              "Didn't expect to set the flash to #{@flash}"
            true
          else
            @failure_message << "Expected the flash to be set to #{@flash} "\
              "but was #{flash_alert_value}"
            false
          end
        end
      end
    end
  end
end
