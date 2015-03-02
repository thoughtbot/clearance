class RemoveConfirmationTokenFromUsers < ActiveRecord::Migration
  def up
    execute <<-SQL
      INSERT INTO password_resets
        (user_id, token, expires_at, created_at, updated_at)
      SELECT
        users.id,
        users.confirmation_token,
        '#{expiration_timestamp}',
        CURRENT_TIMESTAMP,
        CURRENT_TIMESTAMP
      FROM users
      WHERE users.confirmation_token IS NOT NULL
    SQL

    remove_column :users, :confirmation_token
  end

  def expiration_timestamp
    Clearance.
      configuration.
      password_reset_time_limit.
      from_now
  end

  def down
    add_column :users, :confirmation_token, :string, limit: 128

    execute <<-SQL
      UPDATE users
      SET confirmation_token =
        (SELECT token FROM password_resets
         WHERE users.id = password_resets.user_id)
    SQL
  end
end
