require 'clearance'
require 'rails'

module Clearance
  class Engine < Rails::Engine
    initializer 'clearance.filter' do |app|
      app.config.filter_parameters += [:password, :token]
    end

    config.app_middleware.insert_after ActionDispatch::ParamsParser, Clearance::RackSession
  end
end
