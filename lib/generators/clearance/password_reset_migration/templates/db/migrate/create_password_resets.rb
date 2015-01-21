class CreatePasswordResets < ActiveRecord::Migration
  def change
    create_table :password_resets do |t|
      t.integer :user_id, null: false
      t.datetime :expires_at, null: false
      t.timestamps null: false
    end
  end
end
