class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :title
      t.integer :price
      t.integer :weight
      t.string :size
      t.boolean :tangible

      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
