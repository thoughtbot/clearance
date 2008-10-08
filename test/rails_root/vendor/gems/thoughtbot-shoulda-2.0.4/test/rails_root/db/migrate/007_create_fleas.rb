class CreateFleas < ActiveRecord::Migration
  def self.up
    create_table :fleas do |t|
      t.string :name
    end
  end

  def self.down
    drop_table :fleas
  end
end
