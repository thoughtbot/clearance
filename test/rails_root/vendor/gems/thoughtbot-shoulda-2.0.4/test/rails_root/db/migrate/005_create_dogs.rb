class CreateDogs < ActiveRecord::Migration
  def self.up
    create_table :dogs do |t|
      t.column :owner_id, :integer
      t.column :address_id, :integer
    end
  end

  def self.down
    drop_table :dogs
  end
end
