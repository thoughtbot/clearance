class ClearanceFeaturesGenerator < Rails::Generators::Base
  desc "Put the clearance features in place"

  def self.source_root
    @_clearance_source_root ||= File.join(File.dirname(__FILE__), "clearance_features_templates")
  end

  def install
    directory "features"

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
