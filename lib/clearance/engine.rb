require "clearance"
require "rails"

module Clearance
  class Engine < Rails::Engine
    initializer "clearance.filter" do |app|
      app.config.filter_parameters += [:token, :password]
    end
  end
end
