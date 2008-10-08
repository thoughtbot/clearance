class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :name, :string
      t.column :email, :string
      t.column :age, :integer
      t.column :ssn, :string
    end
    add_index :users, :email
    add_index :users, :name
    add_index :users, :age
    add_index :users, [:email, :name]
  end

  def self.down
    drop_table :users
  end
end
