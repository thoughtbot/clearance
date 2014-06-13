class CreatePasswordResets < ActiveRecord::Migration
  def change
    create_table :<%= password_reset_class.tableize %> do |t|
      t.belongs_to :<%= user_class.underscore %>
      t.string :token

      t.timestamps
    end

    add_index :<%= password_reset_class.tableize %>, [:user_id, :token]
  end
end
