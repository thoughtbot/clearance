require 'clearance/constraints/signed_in'
require 'clearance/constraints/signed_out'

module Clearance
  # Clearance provides Rails routing constraints that can control access and the
  # visibility of routes at the routing layer. The {Constraints::SignedIn}
  # constraint can be used to make routes visible only to signed in users. The
  # {Constraints::SignedOut} constraint can be used to make routes visible only
  # to signed out users.
  #
  # @see http://guides.rubyonrails.org/routing.html#advanced-constraints
  module Constraints
  end
end
