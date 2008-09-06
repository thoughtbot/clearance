require 'shoulda/private_helpers'

module ThoughtBot # :nodoc:
  module Shoulda # :nodoc:
    module Macros
      # Macro that creates a test asserting a change between the return value
      # of an expression that is run before and after the current setup block
      # is run. This is similar to Active Support's <tt>assert_difference</tt>
      # assertion, but supports more than just numeric values.  See also
      # should_not_change.
      #
      # Example:
      #
      #   context "Creating a post"
      #     setup do
      #       Post.create
      #     end
      #
      #     should_change "Post.count", :by => 1
      #   end
      #
      # As shown in this example, the <tt>:by</tt> option expects a numeric
      # difference between the before and after values of the expression.  You
      # may also specify <tt>:from</tt> and <tt>:to</tt> options:
      #
      #   should_change "Post.count", :from => 0, :to => 1
      #   should_change "@post.title", :from => "old", :to => "new"
      #
      # Combinations of <tt>:by</tt>, <tt>:from</tt>, and <tt>:to</tt> are allowed:
      #
      #   should_change "@post.title"                # => assert the value changed in some way
      #   should_change "@post.title" :from => "old" # => assert the value changed to anything other than "old"
      #   should_change "@post.title" :to   => "new" # => assert the value changed from anything other than "new"
      def should_change(expression, options = {})
        by, from, to = get_options!([options], :by, :from, :to)
        stmt = "change #{expression.inspect}"
        stmt << " from #{from.inspect}" if from
        stmt << " to #{to.inspect}" if to
        stmt << " by #{by.inspect}" if by

        expression_eval = lambda { eval(expression) }
        before = lambda { @_before_should_change = expression_eval.bind(self).call }
        should stmt, :before => before do
          old_value = @_before_should_change
          new_value = expression_eval.bind(self).call
          assert_operator from, :===, old_value, "#{expression.inspect} did not originally match #{from.inspect}" if from
          assert_not_equal old_value, new_value, "#{expression.inspect} did not change" unless by == 0
          assert_operator to, :===, new_value, "#{expression.inspect} was not changed to match #{to.inspect}" if to
          assert_equal old_value + by, new_value if by
        end
      end

      # Macro that creates a test asserting no change between the return value
      # of an expression that is run before and after the current setup block
      # is run. This is the logical opposite of should_change.
      #
      # Example:
      #
      #   context "Updating a post"
      #     setup do
      #       @post.update_attributes(:title => "new")
      #     end
      #
      #     should_not_change "Post.count"
      #   end
      def should_not_change(expression)
        expression_eval = lambda { eval(expression) }
        before = lambda { @_before_should_not_change = expression_eval.bind(self).call }
        should "not change #{expression.inspect}", :before => before do
          new_value = expression_eval.bind(self).call
          assert_equal @_before_should_not_change, new_value, "#{expression.inspect} changed"
        end
      end

      private

      include ThoughtBot::Shoulda::Private
    end
  end
end
