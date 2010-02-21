require File.expand_path(File.dirname(__FILE__) + "/lib/insert_commands.rb")
require File.expand_path(File.dirname(__FILE__) + "/lib/rake_commands.rb")

class ClearanceGenerator < Rails::Generator::Base

  def manifest
    record do |m|
      m.directory File.join("config", "initializers")
      m.file "clearance.rb", "config/initializers/clearance.rb"

      m.insert_into "app/controllers/application_controller.rb",
                    "include Clearance::Authentication"

      user_model = "app/models/user.rb"
      if File.exists?(user_model)
        m.insert_into user_model, "include Clearance::User"
      else
        m.directory File.join("app", "models")
        m.file "user.rb", user_model
      end

      m.insert_into "config/routes.rb",
                    "Clearance::Routes.draw(map)"

      m.directory File.join("test", "factories")
      m.file "factories.rb", "test/factories/clearance.rb"

      m.migration_template "migrations/#{migration_source_name}.rb",
                           'db/migrate',
                           :migration_file_name => "clearance_#{migration_target_name}"

      m.readme "README"
    end
  end

  def schema_version_constant
    if upgrading_clearance_again?
      "To#{schema_version.gsub('_', '')}"
    end
  end

  private

  def migration_source_name
    if ActiveRecord::Base.connection.table_exists?(:users)
      'update_users'
    else
      'create_users'
    end
  end

  def migration_target_name
    if upgrading_clearance_again?
      "update_users_to_#{schema_version}"
    else
      'create_users'
    end
  end

  def schema_version
    IO.read(File.join(File.dirname(__FILE__), '..', '..', 'VERSION')).strip.gsub(/[^\d]/, '_')
  end

  def upgrading_clearance_again?
    ActiveRecord::Base.connection.table_exists?(:users)
  end

end
