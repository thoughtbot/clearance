module Thoughtbot
  module Shoulda
    class << self
      attr_accessor :expected_exceptions
    end

    # Enables the core shoulda test suite to test for failure scenarios.  For
    # example, to ensure that a set of test macros should fail, do this:
    #
    #   should_fail do
    #     should_require_attributes :comments
    #     should_protect_attributes :name
    #   end
    def should_fail(&block)
      context "should fail when trying to run:" do
        Shoulda.expected_exceptions = [Test::Unit::AssertionFailedError]
        yield block
        Shoulda.expected_exceptions = nil
      end
    end

    class Context
      # alias_method_chain hack to allow the should_fail macro to work
      def should_with_failure_scenario(name, options = {}, &block)
        if Shoulda.expected_exceptions
          expected_exceptions = Shoulda.expected_exceptions
          failure_block = lambda { assert_raise(*expected_exceptions, &block.bind(self)) }
        end
        should_without_failure_scenario(name, options, &(failure_block || block))
      end
      alias_method_chain :should, :failure_scenario
    end
  end
end
