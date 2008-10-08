class CreateTaggings < ActiveRecord::Migration
  def self.up
    create_table :taggings do |t|
      t.column :post_id, :integer
      t.column :tag_id, :integer
    end
  end

  def self.down
    drop_table :taggings
  end
end
