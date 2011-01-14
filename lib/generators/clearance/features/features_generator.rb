require 'diesel/generators/features_base'

module Clearance
  module Generators
    class FeaturesGenerator < Diesel::Generators::FeaturesBase
      def inject_paths
        inject_into_file "features/support/paths.rb", :after => "# Add more mappings here.\n" do
    "    when /the sign up page/i
          sign_up_path
        when /the sign in page/i
          sign_in_path
        when /the password reset request page/i
          new_password_path\n"
        end
      end
    end
  end
end
