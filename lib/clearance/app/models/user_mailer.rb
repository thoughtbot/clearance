module Clearance
  module App
    module Models
      module UserMailer
    
        def self.included(base)
          base.class_eval do
        
            include InstanceMethods
        
          end
        end
    
        module InstanceMethods
          def change_password(user)
            from       DO_NOT_REPLY
            recipients user.email
            subject    "[#{PROJECT_NAME.humanize}] Change your password"
            body       :user => user
          end
        
          def confirmation(user)
            recipients user.email
            from       DO_NOT_REPLY
            subject   "[#{PROJECT_NAME.humanize}] Email confirmation"
            body      :user => user
          end
        end
        
      end
    end
  end
end
