class RemoveConfirmationTokenFromUsers < ActiveRecord::Migration
  def up
    execute <<-SQL
      INSERT INTO password_resets (user_id, token)
      SELECT
        users.id AS user_id,
        users.confirmation_token AS token
      FROM users
      WHERE users.confirmation_token IS NOT NULL
    SQL

    remove_column :users, :confirmation_token
  end

  def down
    add_column :users, :confirmation_token, limit: 128

    execute <<-SQL
      UPDATE users
      SET confirmation_token = password_resets.token
      FROM password_resets
      WHERE users.id = password_resets.user_id
    SQL
  end
end
