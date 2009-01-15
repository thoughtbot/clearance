module Clearance
  module Test
    module Functional
      module UsersControllerTest

        def self.included(base)
          base.class_eval do
            public_context do

              context "on GET to /users/new" do
                setup { get :new }
                should_respond_with :success
                should_render_template :new
                should_not_set_the_flash
                should "display a form to register" do
                 assert_select "form[action=#{users_path}][method=post]", 
                  true, "There must be a form to register" do
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
                
                context "with params" do
                  setup do
                    @email = 'a@example.com'
                    get :new, :user => {:email => @email}
                  end

                  should_assign_to :user
                  should "set the @user's params" do
                    assert_equal @email, assigns(:user).email
                  end
                end
              end

              context "on POST to /users" do
                setup do
                  post :create, :user => Factory.build(:clearance_user).attributes.merge(
                                            {:password => 'skerit',
                                              :password_confirmation => 'skerit'})
                end
            
                should_set_the_flash_to /confirm/i
                should_redirect_to "@controller.send(:url_after_create)"
                should_assign_to :user
                should_change 'User.count', :by => 1
              end

            end

            logged_in_user_context do
              context "GET to new" do
                setup { get :new }
                should_redirect_to 'root_url'
              end

              context "POST to create" do
                setup { post :create, :user => {} }
                should_redirect_to 'root_url'
              end

              should_filter_params :password
            end
          end
        end
      end
    end
  end
end
