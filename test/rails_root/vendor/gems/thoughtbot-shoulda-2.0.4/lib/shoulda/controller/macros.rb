module ThoughtBot # :nodoc:
  module Shoulda # :nodoc:
    module Controller # :nodoc:
      # = Macro test helpers for your controllers
      #
      # By using the macro helpers you can quickly and easily create concise and easy to read test suites.
      #
      # This code segment:
      #   context "on GET to :show for first record" do
      #     setup do
      #       get :show, :id => 1
      #     end
      #
      #     should_assign_to :user
      #     should_respond_with :success
      #     should_render_template :show
      #     should_not_set_the_flash
      #
      #     should "do something else really cool" do
      #       assert_equal 1, assigns(:user).id
      #     end
      #   end
      #
      # Would produce 5 tests for the +show+ action
      #
      # Furthermore, the should_be_restful helper will create an entire set of tests which will verify that your
      # controller responds restfully to a variety of requested formats.
      module Macros
        # <b>DEPRECATED:</b> Please see
        # http://thoughtbot.lighthouseapp.com/projects/5807/tickets/78 for more
        # information.
        #
        # Generates a full suite of tests for a restful controller.
        #
        # The following definition will generate tests for the +index+, +show+, +new+,
        # +edit+, +create+, +update+ and +destroy+ actions, in both +html+ and +xml+ formats:
        #
        #   should_be_restful do |resource|
        #     resource.parent = :user
        #
        #     resource.create.params = { :title => "first post", :body => 'blah blah blah'}
        #     resource.update.params = { :title => "changed" }
        #   end
        #
        # This generates about 40 tests, all of the format:
        #   "on GET to :show should assign @user."
        #   "on GET to :show should not set the flash."
        #   "on GET to :show should render 'show' template."
        #   "on GET to :show should respond with success."
        #   "on GET to :show as xml should assign @user."
        #   "on GET to :show as xml should have ContentType set to 'application/xml'."
        #   "on GET to :show as xml should respond with success."
        #   "on GET to :show as xml should return <user/> as the root element."
        # The +resource+ parameter passed into the block is a ResourceOptions object, and
        # is used to configure the tests for the details of your resources.
        #
        def should_be_restful(&blk) # :yields: resource
          warn "[DEPRECATION] should_be_restful is deprecated.  Please see http://thoughtbot.lighthouseapp.com/projects/5807/tickets/78 for more information."

          resource = ResourceOptions.new
          blk.call(resource)
          resource.normalize!(self)

          resource.formats.each do |format|
            resource.actions.each do |action|
              if self.respond_to? :"make_#{action}_#{format}_tests"
                self.send(:"make_#{action}_#{format}_tests", resource)
              else
                should "test #{action} #{format}" do
                  flunk "Test for #{action} as #{format} not implemented"
                end
              end
            end
          end
        end

        # :section: Test macros
        # Macro that creates a test asserting that the flash contains the given value.
        # val can be a String, a Regex, or nil (indicating that the flash should not be set)
        #
        # Example:
        #
        #   should_set_the_flash_to "Thank you for placing this order."
        #   should_set_the_flash_to /created/i
        #   should_set_the_flash_to nil
        def should_set_the_flash_to(val)
          if val
            should "have #{val.inspect} in the flash" do
              assert_contains flash.values, val, ", Flash: #{flash.inspect}"
            end
          else
            should "not set the flash" do
              assert_equal({}, flash, "Flash was set to:\n#{flash.inspect}")
            end
          end
        end

        # Macro that creates a test asserting that the flash is empty.  Same as
        # @should_set_the_flash_to nil@
        def should_not_set_the_flash
          should_set_the_flash_to nil
        end
        
        # Macro that creates a test asserting that filter_parameter_logging
        # is set for the specified keys
        #
        # Example:
        #
        #   should_filter_params :password, :ssn
        def should_filter_params(*keys)
          keys.each do |key|
            should "filter #{key}" do
              assert @controller.respond_to?(:filter_parameters),
                "The key #{key} is not filtered"
              filtered = @controller.send(:filter_parameters, {key.to_s => key.to_s})
              assert_equal '[FILTERED]', filtered[key.to_s],
                "The key #{key} is not filtered"
            end
          end
        end

        # Macro that creates a test asserting that the controller assigned to
        # each of the named instance variable(s).
        #
        # Options:
        # * <tt>:class</tt> - The expected class of the instance variable being checked.
        # * <tt>:equals</tt> - A string which is evaluated and compared for equality with
        # the instance variable being checked.
        #
        # Example:
        #
        #   should_assign_to :user, :posts
        #   should_assign_to :user, :class => User
        #   should_assign_to :user, :equals => '@user'
        def should_assign_to(*names)
          opts = names.extract_options!
          names.each do |name|
            test_name = "assign @#{name}"
            test_name << " as class #{opts[:class]}" if opts[:class]
            test_name << " which is equal to #{opts[:equals]}" if opts[:equals]
            should test_name do
              assigned_value = assigns(name.to_sym)
              assert assigned_value, "The action isn't assigning to @#{name}"
              assert_kind_of opts[:class], assigned_value if opts[:class]
              if opts[:equals]
                instantiate_variables_from_assigns do
                  expected_value = eval(opts[:equals], self.send(:binding), __FILE__, __LINE__)
                  assert_equal expected_value, assigned_value,
                               "Instance variable @#{name} expected to be #{expected_value}" +
                               " but was #{assigned_value}"
                end
              end
            end
          end
        end

        # Macro that creates a test asserting that the controller did not assign to
        # any of the named instance variable(s).
        #
        # Example:
        #
        #   should_not_assign_to :user, :posts
        def should_not_assign_to(*names)
          names.each do |name|
            should "not assign to @#{name}" do
              assert !assigns(name.to_sym), "@#{name} was visible"
            end
          end
        end

        # Macro that creates a test asserting that the controller responded with a 'response' status code.
        # Example:
        #
        #   should_respond_with :success
        def should_respond_with(response)
          should "respond with #{response}" do
            assert_response response
          end
        end

        # Macro that creates a test asserting that the response content type was 'content_type'.
        # Example:
        #
        #   should_respond_with_content_type 'application/rss+xml'
        #   should_respond_with_content_type :rss
        #   should_respond_with_content_type /rss/
        def should_respond_with_content_type(content_type)
          should "respond with content type of #{content_type}" do
            content_type = Mime::EXTENSION_LOOKUP[content_type.to_s].to_s if content_type.is_a? Symbol
            if content_type.is_a? Regexp
              assert_match content_type, @response.content_type, "Expected to match #{content_type} but was actually #{@response.content_type}"
            else
              assert_equal content_type, @response.content_type, "Expected #{content_type} but was actually #{@response.content_type}"
            end
          end
        end

        # Macro that creates a test asserting that a value returned from the session is correct.
        # The given string is evaled to produce the resulting redirect path.  All of the instance variables
        # set by the controller are available to the evaled string.
        # Example:
        #
        #   should_return_from_session :user_id, '@user.id'
        #   should_return_from_session :message, '"Free stuff"'
        def should_return_from_session(key, expected)
          should "return the correct value from the session for key #{key}" do
            instantiate_variables_from_assigns do
              expected_value = eval(expected, self.send(:binding), __FILE__, __LINE__)
              assert_equal expected_value, session[key], "Expected #{expected_value.inspect} but was #{session[key]}"
            end
          end
        end

        # Macro that creates a test asserting that the controller rendered the given template.
        # Example:
        #
        #   should_render_template :new
        def should_render_template(template)
          should "render template #{template.inspect}" do
            assert_template template.to_s
          end
        end

        # Macro that creates a test asserting that the controller rendered with the given layout.
        # Example:
        #
        #   should_render_with_layout 'special'
        def should_render_with_layout(expected_layout = 'application')
          if expected_layout
            should "render with #{expected_layout} layout" do
              response_layout = @response.layout.blank? ? "" : @response.layout.split('/').last
              assert_equal expected_layout,
                           response_layout,
                           "Expected to render with layout #{expected_layout} but was rendered with #{response_layout}"
            end
          else
            should "render without layout" do
              assert_nil @response.layout,
                         "Expected no layout, but was rendered using #{@response.layout}"
            end
          end
        end

        # Macro that creates a test asserting that the controller rendered without a layout.
        # Same as @should_render_with_layout false@
        def should_render_without_layout
          should_render_with_layout nil
        end

        # Macro that creates a test asserting that the controller returned a redirect to the given path.
        # The given string is evaled to produce the resulting redirect path.  All of the instance variables
        # set by the controller are available to the evaled string.
        # Example:
        #
        #   should_redirect_to '"/"'
        #   should_redirect_to "user_url(@user)"
        #   should_redirect_to "users_url"
        def should_redirect_to(url)
          should "redirect to #{url.inspect}" do
            instantiate_variables_from_assigns do
              assert_redirected_to eval(url, self.send(:binding), __FILE__, __LINE__)
            end
          end
        end

        # Macro that creates a test asserting that the rendered view contains a <form> element.
        def should_render_a_form
          should "display a form" do
            assert_select "form", true, "The template doesn't contain a <form> element"
          end
        end

        # Macro that creates a routing test. It tries to use the given HTTP
        # +method+ on the given +path+, and asserts that it routes to the
        # given +options+.
        #
        # If you don't specify a :controller, it will try to guess the controller
        # based on the current test.
        #
        # +to_param+ is called on the +options+ given.
        #
        # Examples:
        #
        #   should_route :get, "/posts", :controller => :posts, :action => :index
        #   should_route :get, "/posts/new", :action => :new
        #   should_route :post, "/posts", :action => :create
        #   should_route :get, "/posts/1", :action => :show, :id => 1
        #   should_route :edit, "/posts/1", :action => :show, :id => 1
        #   should_route :put, "/posts/1", :action => :update, :id => 1
        #   should_route :delete, "/posts/1", :action => :destroy, :id => 1
        #   should_route :get, "/users/1/posts/1", 
        #     :action => :show, :id => 1, :user_id => 1
        #
        def should_route(method, path, options)
          unless options[:controller]
            options[:controller] = self.name.gsub(/ControllerTest$/, '').tableize
          end
          options[:controller] = options[:controller].to_s
          options[:action] = options[:action].to_s

          populated_path = path.dup
          options.each do |key, value|
            options[key] = value.to_param if value.respond_to? :to_param
            populated_path.gsub!(key.inspect, value.to_s)
          end

          should_name = "route #{method.to_s.upcase} #{populated_path} to/from #{options.inspect}"

          should should_name do
            assert_routing({:method => method, :path => populated_path}, options)
          end
        end
      end
    end
  end
end
