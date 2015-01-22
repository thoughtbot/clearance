class CreatePasswordResets < ActiveRecord::Migration
  def change
    create_table :password_resets do |t|
      t.integer :user_id, null: false
      t.string :token, limit: 128, null: false
      t.datetime :expires_at, null: false, default: 20.minutes.from_now
      t.timestamps null: false
    end

    add_index :password_resets, :user_id
  end
end
