require "clerance/testing/controller_helpers"

module Clearance
  module Testing
    # @deprecated Use Clearance::Testing::ControllerHelpers
    module Helpers
      warn(
        "#{Kernel.caller.first} [DEPRECATION] Clearance::Testing::Helpers is "\
        "deprecated and has been replaced with " \
        "Clearance::Testing::ControllerHelpers. Require " \
        "clearance/testing/controller_helpers instead."
      )
    end
  end
end
