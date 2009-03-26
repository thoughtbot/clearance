require File.expand_path(File.dirname(__FILE__) + "/lib/insert_commands.rb")
require File.expand_path(File.dirname(__FILE__) + "/lib/rake_commands.rb")
require 'factory_girl'

class ClearanceGenerator < Rails::Generator::Base

  def manifest
    record do |m|
      m.insert_into "app/controllers/application_controller.rb",
                    "include Clearance::Authentication"

      m.directory File.join("app", "models")
      m.file "user.rb", "app/models/user.rb"

      m.directory File.join("test", "factories")
      m.file "factories.rb", "test/factories/clearance.rb"

      m.route_resources ':passwords'
      m.route_resource  ':session'
      m.route_resources ':users, :has_one => [:password, :confirmation]'

      m.migration_template "migrations/#{migration_name}.rb",
                           'db/migrate',
                           :migration_file_name => "clearance_#{migration_name}"

      m.readme "README"
    end
  end

  private

  def migration_name
    if ActiveRecord::Base.connection.table_exists?(:users)
      'update_users'
    else
      'create_users'
    end
  end

end
