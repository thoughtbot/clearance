class ClearanceViewsGenerator < Rails::Generators::Base
  desc "Put the clearance views in place"

  def self.source_root
    @_clearance_source_root ||= File.join(File.dirname(__FILE__), "clearance_views_templates")
  end

  def install
    strategy          = "formtastic"
    template_strategy = "erb"

    directory "#{strategy}/#{template_strategy}", "app/views"
  end
end
