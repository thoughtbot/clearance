module Clearance
  module Shoulda

    # STATE OF AUTHENTICATION

    def should_be_signed_in_as(&block)
      should "be signed in as #{block.bind(self).call}" do
        user = block.bind(self).call
        assert_not_nil user,
          "please pass a User. try: should_be_signed_in_as { @user }"
        assert_equal user.id,   session[:user_id],
          "session[:user_id] is not set to User's id"
      end
    end

    def should_be_signed_in_and_email_confirmed_as(&block)
      should_be_signed_in_as &block

      should "have confirmed email" do
        user = block.bind(self).call

        assert_not_nil user
        assert_equal user, assigns(:user)
        assert assigns(:user).email_confirmed?
      end
    end

    def should_not_be_signed_in
      should "not be signed in" do
        assert_nil session[:user_id]
      end
    end

    def should_deny_access_on(command, opts = {})
      context "on #{command}" do
        setup { eval command }
        should_deny_access(opts)
      end
    end

    def should_deny_access(opts = {})
      if opts[:flash]
        should_set_the_flash_to opts[:flash]
      else
        should_not_set_the_flash
      end

      should "respond with 401 Unauthorized and render sign_in template" do
        assert_response :unauthorized,
          "access was expected to be denied (401 unauthorized)"
        assert_template "sessions/new",
          "template was expected to be sign in (sessions/new)"
      end
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
      context "The public" do
        setup { sign_out }
        merge_block(&blk)
      end
    end

    # CREATING USERS

    def should_create_user_successfully
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

    # VALIDATIONS

    def should_validate_confirmation_of(attribute, opts = {})
      raise ArgumentError if opts[:factory].nil?

      context "on save" do
        should_validate_confirmation_is_not_blank opts[:factory], attribute
        should_validate_confirmation_is_not_bad   opts[:factory], attribute
      end
    end

    def should_validate_confirmation_is_not_blank(factory, attribute, opts = {})
      should "validate #{attribute}_confirmation is not blank" do
        model = Factory.build(factory, blank_confirmation_options(attribute))
        model.save
        assert_confirmation_error(model, attribute,
          "#{attribute}_confirmation cannot be blank")
      end
    end

    def should_validate_confirmation_is_not_bad(factory, attribute, opts = {})
      should "validate #{attribute}_confirmation is different than #{attribute}" do
        model = Factory.build(factory, bad_confirmation_options(attribute))
        model.save
        assert_confirmation_error(model, attribute, 
          "#{attribute}_confirmation cannot be different than #{attribute}")
      end
    end

    # FORMS

    def should_display_a_password_update_form
      should "have a form for the user's token, password, and password confirm" do
        update_path = ERB::Util.h(
          user_password_path(@user, :token => @user.token)
        )

        assert_select 'form[action=?]', update_path do
          assert_select 'input[name=_method][value=?]', 'put'
          assert_select 'input[name=?]', 'user[password]'
          assert_select 'input[name=?]', 'user[password_confirmation]'
        end
      end
    end

    def should_display_a_sign_up_form
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
      should 'display a "sign in" form' do
        assert_select "form[action=#{session_path}][method=post]",
          true, "There must be a form to sign in" do
            assert_select "input[type=text][name=?]",
              "session[email]", true, "There must be an email field"
            assert_select "input[type=password][name=?]",
              "session[password]", true, "There must be a password field"
            assert_select "input[type=checkbox][name=?]",
              "session[remember_me]", true, "There must be a 'remember me' check box"
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
      def sign_in_as(user = nil)
        unless user
          user = Factory(:user)
          user.confirm_email!
        end
        @request.session[:user_id] = user.id
        return user
      end

      def sign_out
        @request.session[:user_id] = nil
      end

      def blank_confirmation_options(attribute)
        opts = { attribute => attribute.to_s }
        opts.merge("#{attribute}_confirmation".to_sym => "")
      end

      def bad_confirmation_options(attribute)
        opts = { attribute => attribute.to_s }
        opts.merge("#{attribute}_confirmation".to_sym => "not_#{attribute}")
      end

      def assert_confirmation_error(model, attribute, message = "confirmation error")
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
