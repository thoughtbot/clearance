class CreateClearancePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.timestamps null: false
      t.string :email, null: false
      t.string :encrypted_password, limit: 128, null: false
      t.string :confirmation_token, limit: 128
      t.string :remember_token, limit: 128, null: false
    end

    add_index :people, :email
    add_index :people, :remember_token
  end

  def self.down
    drop_table :people
  end
end
