class ClearanceViewsGenerator < Rails::Generators::Base
  desc "Put the clearance views in place"

  def self.source_root
    @_clearance_source_root ||= File.expand_path("../../../../../../../../../generators/clearance_views/templates", __FILE__)
  end

  def install
    strategy          = "formtastic"
    template_strategy = "erb"

    directory "#{strategy}/#{template_strategy}", "app/views"
  end
end
