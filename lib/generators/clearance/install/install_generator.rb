require 'rails/generators/base'

module Clearance
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def add_routes
        route(%{get "sign_up" => "clearance/sign_ups#new"})
        route(%{post "sign_up" => "clearance/sign_ups#create"})
        route(%{get "sign_in" => "clearance/sessions#new"})
        route(%{post "sign_in" => "clearance/sessions#create"})
        route(%{delete "sign_out" => "clearance/sessions#destroy"})
      end

      def add_controller_helpers
        inject_into_class(
          "app/controllers/application_controller.rb",
          ApplicationController,
          "  include Monban::ControllerHelpers\n"
        )
      end
    end
  end
end
