require 'rails/generators/active_record'

class ClearanceGenerator < ActiveRecord::Generators::Base
  desc "Setup the basic stuff needed for Clearance"

  argument :name, :type => :string, :default => "migration_source_name"

  def self.source_root
    @_clearance_source_root ||= File.join(File.dirname(__FILE__), "clearance_templates")
  end

  def install
    template "clearance.rb", "config/initializers/clearance.rb"

    inject_into_class "app/controllers/application_controller.rb", ApplicationController do
      "  include Clearance::Authentication\n"
    end

    user_model = "app/models/user.rb"
    if File.exists?(user_model)
      inject_into_class user_model, User do
        "include Clearance::User"
      end
    else
      template "user.rb", user_model
    end

    template "factories.rb", "test/factories/clearance.rb"

    migration_template "migrations/#{migration_source_name}.rb",
                       "db/migrate/clearance_#{migration_target_name}"

    #readme "README"
  end

  private

  def schema_version_constant
    if upgrading_clearance_again?
      "To#{schema_version.gsub('_', '')}"
    end
  end

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
