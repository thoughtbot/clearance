class CreateDogsFleas < ActiveRecord::Migration
  def self.up
    create_table :dogs_fleas do |t|
      t.integer :dog_id
      t.integer :flea_id
    end
  end

  def self.down
    drop_table :dogs_fleas
  end
end
