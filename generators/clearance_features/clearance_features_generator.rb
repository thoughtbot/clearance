class ClearanceFeaturesGenerator < Rails::Generator::Base

  def manifest
    record do |m|
      m.directory File.join("features", "step_definitions")
      m.directory File.join("features", "support")

      ["features/step_definitions/clearance_steps.rb",
       "features/step_definitions/factory_girl_steps.rb",
       "features/support/paths.rb",
       "features/sign_in.feature",
       "features/sign_out.feature",
       "features/sign_up.feature",
       "features/password_reset.feature"].each do |file|
        m.file file, file
       end
    end
  end

end
