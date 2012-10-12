require 'rails/generators/base'

module Clearance
  module Generators
    class ViewsGenerator < Rails::Generators::Base
      source_root Clearance.root

      def create_views
        views.each do |view|
          copy_file view
        end
      end

      private

      def views
        files_within_root('.', 'app/views/**/*.*')
      end

      def files_within_root(prefix, glob)
        root = "#{self.class.source_root}/#{prefix}"

        Dir["#{root}/#{glob}"].sort.map do |full_path|
          full_path.sub(root, '.').gsub('/./', '/')
        end
      end
    end
  end
end
