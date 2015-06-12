module Clearance
  module Testing
    # Provides helpers to your view and helper specs.
    # Using these helpers makes `current_user`, `signed_in?` and `signed_out?`
    # behave properly in view and helper specs.
    module ViewHelpers
      # Sets current_user on the view under test to a new instance of your user
      # model.
      def sign_in
        view.current_user = Clearance.configuration.user_model.new
      end

      # Sets current_user on the view under test to the supplied user.
      def sign_in_as(user)
        view.current_user = user
      end

      # @private
      module CurrentUser
        attr_accessor :current_user

        def signed_in?
          current_user.present?
        end

        def signed_out?
          !signed_in?
        end
      end
    end
  end
end
