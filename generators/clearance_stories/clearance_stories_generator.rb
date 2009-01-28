class ClearanceStoriesGenerator < Rails::Generator::Base
  
  def manifest
    record do |m|
      m.directory File.join("features", "step_definitions")
      
      ["features/step_definitions/clearance_steps.rb",
       "features/signin.feature",
       "features/signout.feature",       
       "features/signup.feature"].each do |file|
        m.file file, file
       end
    end
  end
  
end
