class CreateOrUpdateUsersWithClearanceColumns < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.string :email
      t.string :encrypted_password, :limit => 40
      t.string :salt, :limit => 40
      t.string :remember_token
      t.datetime :remember_token_expires_at
      t.boolean :confirmed, :default => false, :null => false
    end

    add_index :users, [:email, :encrypted_password]
    add_index :users, [:id, :salt]
    add_index :users, :email
    add_index :users, :remember_token    
  end
  
  def self.down
    drop_table :users  
  end
end
