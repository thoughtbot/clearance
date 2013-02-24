require 'clearance/authentication'
require 'clearance/authorization'

module Clearance
  module Controller
    extend ActiveSupport::Concern

    include Clearance::Authentication
    include Clearance::Authorization
  end
end
