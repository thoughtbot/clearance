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
        # :section: should_be_restful
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

        # Macro that creates a test asserting that the controller assigned to
        # each of the named instance variable(s).
        #
        # Example:
        #
        #   should_assign_to :user, :posts
        def should_assign_to(*names)
          names.each do |name|
            should "assign @#{name}" do
              assert assigns(name.to_sym), "The action isn't assigning to @#{name}"
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

        # Macro that creates a test asserting that the controller rendered the given template.
        # Example:
        #
        #   should_render_template :new
        def should_render_template(template)
          should "render template #{template.inspect}" do
            assert_template template.to_s
          end
        end

        # Macro that creates a test asserting that the controller returned a redirect to the given path.
        # The given string is evaled to produce the resulting redirect path.  All of the instance variables
        # set by the controller are available to the evaled string.
        # Example:
        #
        #   should_redirect_to '"/"'
        #   should_redirect_to "users_url(@user)"
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
      end
    end
  end
end
