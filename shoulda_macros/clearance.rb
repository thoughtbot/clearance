module Clearance
  module Shoulda

    # STATE OF AUTHENTICATION

    def should_be_signed_in_as(&block)
      warn "[DEPRECATION] should_be_signed_in_as cannot be used in functional tests anymore now that it depends on cookies, which are unavailable until the next request."
      should "be signed in as #{block.bind(self).call}" do
        user = block.bind(self).call
        assert_not_nil user,
          "please pass a User. try: should_be_signed_in_as { @user }"
        assert_equal user, @controller.send(:current_user),
          "#{user.inspect} is not the current_user, " <<
          "which is #{@controller.send(:current_user).inspect}"
      end
    end

    def should_be_signed_in_and_email_confirmed_as(&block)
      warn "[DEPRECATION] should_be_signed_in_and_email_confirmed_as: questionable usefulness"
      should_be_signed_in_as &block

      should "have confirmed email" do
        user = block.bind(self).call

        assert_not_nil user
        assert_equal user, assigns(:user)
        assert assigns(:user).email_confirmed?
      end
    end

    def should_not_be_signed_in
      warn "[DEPRECATION] should_not_be_signed_in is no longer a valid test since we now store a remember_token in cookies, not user_id in session"
      should "not be signed in" do
        assert_nil session[:user_id]
      end
    end

    def should_deny_access_on(http_method, action, opts = {})
      warn "[DEPRECATION] should_deny_access_on: use a setup & should_deny_access(:flash => ?)"
      flash_message = opts.delete(:flash)
      context "on #{http_method} to #{action}" do
        setup do
          send(http_method, action, opts)
        end

        should_deny_access(:flash => flash_message)
      end
    end

    def should_deny_access(opts = {})
      if opts[:flash]
        should_set_the_flash_to opts[:flash]
      else
        should_not_set_the_flash
      end

      should_redirect_to('sign in page') { sign_in_url }
    end

    # HTTP FLUENCY

    def should_forbid(description, &block)
      should "forbid #{description}" do
        assert_raises ActionController::Forbidden do
          instance_eval(&block)
        end
      end
    end

    # CONTEXTS

    def signed_in_user_context(&blk)
      warn "[DEPRECATION] signed_in_user_context: creates a Mystery Guest, causes Obscure Test"
      context "A signed in user" do
        setup do
          @user = Factory(:user)
          @user.confirm_email!
          sign_in_as @user
        end
        merge_block(&blk)
      end
    end

    def public_context(&blk)
      warn "[DEPRECATION] public_context: common case is no-op. call sign_out otherwise"
      context "The public" do
        setup { sign_out }
        merge_block(&blk)
      end
    end

    # CREATING USERS

    def should_create_user_successfully
      warn "[DEPRECATION] should_create_user_successfully: not meant to be public, no longer used internally"
      should_assign_to :user
      should_change 'User.count', :by => 1

      should "send the confirmation email" do
        assert_sent_email do |email|
          email.subject =~ /account confirmation/i
        end
      end

      should_set_the_flash_to /confirm/i
      should_redirect_to_url_after_create
    end

    # RENDERING

    def should_render_nothing
      should "render nothing" do
        assert @response.body.blank?
      end
    end

    # REDIRECTS

    def should_redirect_to_url_after_create
      should_redirect_to("the post-create url") do
        @controller.send(:url_after_create)
      end
    end

    def should_redirect_to_url_after_update
      should_redirect_to("the post-update url") do
        @controller.send(:url_after_update)
      end
    end

    def should_redirect_to_url_after_destroy
      should_redirect_to("the post-destroy url") do
        @controller.send(:url_after_destroy)
      end
    end

    def should_redirect_to_url_already_confirmed
      should_redirect_to("the already confirmed url") do
        @controller.send(:url_already_confirmed)
      end
    end

    # VALIDATIONS

    def should_validate_confirmation_of(attribute, opts = {})
      warn "[DEPRECATION] should_validate_confirmation_of: not meant to be public, no longer used internally"
      raise ArgumentError if opts[:factory].nil?

      context "on save" do
        should_validate_confirmation_is_not_blank opts[:factory], attribute
        should_validate_confirmation_is_not_bad   opts[:factory], attribute
      end
    end

    def should_validate_confirmation_is_not_blank(factory, attribute, opts = {})
      warn "[DEPRECATION] should_validate_confirmation_is_not_blank: not meant to be public, no longer used internally"
      should "validate #{attribute}_confirmation is not blank" do
        model = Factory.build(factory, blank_confirmation_options(attribute))
        model.save
        assert_confirmation_error(model, attribute,
          "#{attribute}_confirmation cannot be blank")
      end
    end

    def should_validate_confirmation_is_not_bad(factory, attribute, opts = {})
      warn "[DEPRECATION] should_validate_confirmation_is_not_bad: not meant to be public, no longer used internally"
      should "validate #{attribute}_confirmation is different than #{attribute}" do
        model = Factory.build(factory, bad_confirmation_options(attribute))
        model.save
        assert_confirmation_error(model, attribute, 
          "#{attribute}_confirmation cannot be different than #{attribute}")
      end
    end

    # FORMS

    def should_display_a_password_update_form
      warn "[DEPRECATION] should_display_a_password_update_form: not meant to be public, no longer used internally"
      should "have a form for the user's token, password, and password confirm" do
        update_path = ERB::Util.h(
          user_password_path(@user, :token => @user.confirmation_token)
        )

        assert_select 'form[action=?]', update_path do
          assert_select 'input[name=_method][value=?]', 'put'
          assert_select 'input[name=?]', 'user[password]'
          assert_select 'input[name=?]', 'user[password_confirmation]'
        end
      end
    end

    def should_display_a_sign_up_form
      warn "[DEPRECATION] should_display_a_sign_up_form: not meant to be public, no longer used internally"
      should "display a form to sign up" do
        assert_select "form[action=#{users_path}][method=post]",
        true, "There must be a form to sign up" do
          assert_select "input[type=text][name=?]",
            "user[email]", true, "There must be an email field"
          assert_select "input[type=password][name=?]",
            "user[password]", true, "There must be a password field"
          assert_select "input[type=password][name=?]",
            "user[password_confirmation]", true, "There must be a password confirmation field"
          assert_select "input[type=submit]", true,
            "There must be a submit button"
        end
      end
    end

    def should_display_a_sign_in_form
      warn "[DEPRECATION] should_display_a_sign_in_form: not meant to be public, no longer used internally"
      should 'display a "sign in" form' do
        assert_select "form[action=#{session_path}][method=post]",
          true, "There must be a form to sign in" do
            assert_select "input[type=text][name=?]",
              "session[email]", true, "There must be an email field"
            assert_select "input[type=password][name=?]",
              "session[password]", true, "There must be a password field"
            assert_select "input[type=submit]", true,
              "There must be a submit button"
        end
      end
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

      def blank_confirmation_options(attribute)
        warn "[DEPRECATION] blank_confirmation_options: not meant to be public, no longer used internally"
        opts = { attribute => attribute.to_s }
        opts.merge("#{attribute}_confirmation".to_sym => "")
      end

      def bad_confirmation_options(attribute)
        warn "[DEPRECATION] bad_confirmation_options: not meant to be public, no longer used internally"
        opts = { attribute => attribute.to_s }
        opts.merge("#{attribute}_confirmation".to_sym => "not_#{attribute}")
      end

      def assert_confirmation_error(model, attribute, message = "confirmation error")
        warn "[DEPRECATION] assert_confirmation_error: not meant to be public, no longer used internally"
        assert model.errors.on(attribute).include?("doesn't match confirmation"),
          message
      end
    end
  end
end

class Test::Unit::TestCase
  include Clearance::Shoulda::Helpers
end
Test::Unit::TestCase.extend(Clearance::Shoulda)
