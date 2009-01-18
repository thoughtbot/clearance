module Clearance 
  module Shoulda

    # STATE OF AUTHENTICATION

    def should_be_logged_in_as(&block)
      should "be logged in as #{block.bind(self).call}" do
        user = block.bind(self).call
        assert_not_nil user, 
          "please pass a User. try: should_be_logged_in_as { @user }"
        assert_equal user.id,   session[:user_id], 
          "session[:user_id] is not set to User's id"
        assert_equal user.salt, session[:salt], 
          "session[:salt] is not set to User's salt"
      end
    end

    def should_be_logged_in_and_email_confirmed_as(&block)
      should_be_logged_in_as &block
      
      should "have confirmed email" do
        user = block.bind(self).call
        assert_not_nil user
        assert_equal user, assigns(:user)
        assert assigns(:user).email_confirmed?
      end
    end
    
    def should_not_be_logged_in
      should "not be logged in" do
        assert_nil session[:user_id]
        assert_nil session[:salt]
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
      
      should "respond with 401 Unauthorized and render login template" do
        assert_response :unauthorized, 
          "access was expected to be denied (401 unauthorized)"
        assert_template "sessions/new",
          "template was expected to be login (sessions/new)"
      end
    end
    
    # CONTEXTS

    def logged_in_user_context(&blk)
      context "A logged in user" do
        setup do
          @user = Factory(:authorized_user)
          @user.confirm_email!
          login_as @user
        end
        merge_block(&blk)
      end
    end

    def public_context(&blk)
      context "The public" do
        setup { logout }
        merge_block(&blk)
      end
    end
    
    # RENDERING
    
    def should_render_nothing
      should "render nothing" do
        assert @response.body.blank?
      end
    end
    
    # REDIRECTS
    
    def should_redirect_to_url_after_create
      should_redirect_to "@controller.send(:url_after_create)"
    end
    
    def should_redirect_to_url_after_update
      should_redirect_to "@controller.send(:url_after_update)"
    end
    
    def should_redirect_to_url_after_destroy
      should_redirect_to "@controller.send(:url_after_destroy)"
    end
    
    # VALIDATIONS
    
    # This Shoulda macro also depends on Factory Girl
    # default :on => :save, other options :create, :update    
    def should_validate_confirmation_of(factory, attribute, opts = { :on => :save })
      
      if opts[:on] == :save
        context "#{attribute} is not correctly confirmed" do
          setup do
            @model = Factory.build(factory, 
                      attribute                               => attribute.to_s, 
                      "#{attribute.to_s}_confirmation".to_sym => "unconfirmed_#{attribute.to_s}")
            @model.save
          end
        
          should "be invalid" do
            assert ! @model.valid?, "#{attribute} was not confirmed but #{@model.class} saved anyway"
          end

          should "raise confirmation error on #{attribute}" do
            assert_match(/confirmation/i, @model.errors.on(attribute))
          end
        end
      
        context "#{attribute} is blank" do
          setup do
            @model = Factory.build(factory,
                      attribute                               => "", 
                      "#{attribute.to_s}_confirmation".to_sym => "unconfirmed_#{attribute.to_s}")
            @model.save
          end
        
          should "be invalid" do
            assert ! @model.valid?, "#{attribute} was not confirmed but #{@model.class} saved anyway"
          end

          should "raise blank and confirmation error on #{attribute}" do
            errors = @model.errors.on(attribute)
            confirmation_errors = errors.collect { |each| each =~ /confirmation/i }
            blank_errors = errors.collect { |each| each =~ /blank/i }
            assert confirmation_errors.any?, "no confirmation error on #{attribute}"
            assert blank_errors.any?, "no blank error on #{attribute}"
          end
        end
      end
      
    end
    
  end
end

Test::Unit::TestCase.extend(Clearance::Shoulda)
