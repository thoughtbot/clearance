module Clearance
  module Shoulda
    # STATE OF AUTHENTICATION

    def should_deny_access(opts = {})
      if opts[:flash]
        should set_the_flash.to(opts[:flash])
      else
        should_not set_the_flash
      end

      should redirect_to('sign in page') { sign_in_url }
    end

    # HTTP FLUENCY

    def should_forbid(description, &block)
      warn "[DEPRECATION] should_forbid and Clearance's ActionController::Forbidden have been removed. Setting the 403 status code turned out to be an awful user experience in some browsers such as Chrome on Windows machines."
    end

    # RENDERING

    def should_render_nothing
      should "render nothing" do
        assert @response.body.blank?
      end
    end

    # REDIRECTS

    def should_redirect_to_url_after_create
      should redirect_to("the post-create url") { @controller.send(:url_after_create) }
    end

    def should_redirect_to_url_after_update
      should redirect_to("the post-update url") { @controller.send(:url_after_update) }
    end

    def should_redirect_to_url_after_destroy
      should redirect_to("the post-destroy url") { @controller.send(:url_after_destroy) }
    end

    def should_redirect_to_url_already_confirmed
      should redirect_to("the already confirmed url") { @controller.send(:url_already_confirmed) }
    end
  end
end

module Clearance
  module Shoulda
    module Helpers
      def sign_in_as(user)
        @controller.current_user = user
        return user
      end

      def sign_in
        sign_in_as Factory(:email_confirmed_user)
      end

      def sign_out
        @controller.current_user = nil
      end
    end
  end
end

class Test::Unit::TestCase
  include Clearance::Shoulda::Helpers
end
Test::Unit::TestCase.extend(Clearance::Shoulda)
