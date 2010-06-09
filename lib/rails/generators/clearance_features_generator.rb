class ClearanceFeaturesGenerator < Rails::Generators::Base
  desc "Put the clearance features in place"

  def self.source_root
    @_clearance_source_root ||= File.expand_path("../../../../../../../../../generators/clearance_features/templates", __FILE__)
  end

  def install
    directory "features"
  end
end
