module Clearance 
  module Test
    module TestHelper
    
      def self.included(base)
        base.class_eval do
          include InstanceMethods
          extend ClassMethods
        end
      end

      module InstanceMethods
        def login_as(user = nil)
          user ||= Factory(:user)
          @request.session[:user_id] = user.id
          return user
        end

        def logout 
          @request.session[:user_id] = nil
        end
      end
    
      module ClassMethods
        def should_deny_access_on(command, opts = {})

          context "on #{command}" do
            setup { eval command }
            should_deny_access(opts)
          end
        end

        def should_deny_access(opts = {})
          opts[:redirect] ||= "new_session_path"
          should_redirect_to opts[:redirect]
          if opts[:flash]
            should_set_the_flash_to opts[:flash]
          else
            should_not_set_the_flash
          end
        end
      
        # should_have_form :action => 'admin_users_path',
        #   :method => :get, 
        #   :fields => { 'email' => :text }
        # TODO: http_method should be pulled out
        def should_have_form(opts)
          model = self.name.gsub(/ControllerTest$/, '').singularize.downcase
          model = model[model.rindex('::')+2..model.size] if model.include?('::')
          http_method, hidden_http_method = form_http_method opts[:method]
          should "have a #{model} form" do
            assert_select "form[action=?][method=#{http_method}]", eval(opts[:action]) do
              if hidden_http_method
                assert_select "input[type=hidden][name=_method][value=#{hidden_http_method}]"
              end
              opts[:fields].each do |attribute, type|
                attribute = attribute.is_a?(Symbol) ? "#{model}[#{attribute.to_s}]" : attribute
                assert_select "input[type=#{type.to_s}][name=?]", attribute
              end
              assert_select "input[type=submit]"
            end
          end
        end
      
        def form_http_method(http_method)
          http_method = http_method.nil? ? 'post' : http_method.to_s
          if http_method == "post" || http_method == "get"
            return http_method, nil
          else
            return "post", http_method
          end
        end
      
        def logged_in_user_context(&blk)
          context "A logged in user" do
            setup do
              @user = Factory :user
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
      end
 
    end 
  end
end
