module Clearance
  module App
    module Models
      module ClearanceMailer

        def change_password(user)
          from       DO_NOT_REPLY
          recipients user.email
          subject    "Change your password"
          body       :user => user
        end

        def confirmation(user)
          from       DO_NOT_REPLY
          recipients user.email
          subject   "Account confirmation"
          body      :user => user
        end

      end
    end
  end
end
