if defined?(RSpec)
  require 'clearance/rspec'
elsif defined?(ActionController::TestCase)
  require 'clearance/test_unit'
end

warn(
  "#{Kernel.caller.first} [DEPRECATION] Requiring `clearance/testing` in " +
  '`spec/spec_helper.rb` (or in `test/test_helper.rb`) is deprecated. ' +
  'Require `clearance/rspec` or `clearance/test_unit` instead.'
)
