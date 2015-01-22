class RemoveConfirmationTokenFromUsers < ActiveRecord::Migration
  def up
    expiration_timestamp = Clearance.configuration.
      password_reset_time_limit.
      from_now

    execute <<-SQL
      INSERT INTO password_resets (user_id, token, expires_at)
      SELECT
        users.id AS user_id,
        users.confirmation_token AS token,
        #{expiration_timestamp} AS expires_at
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
