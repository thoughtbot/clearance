module Clearance
  module Mailers
    module User
    
      def self.included(base)
        base.class_eval do
        
          include InstanceMethods
        
        end
      end
    
      module InstanceMethods
        def change_password(user)
          from       "donotreply@example.com"
          recipients user.email
          subject    "[YOUR APP] Request to change your password"
          body       :user => user
        end
      end
    end
  end
end
