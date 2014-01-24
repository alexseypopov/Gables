class IndexFieldsOnImages < ActiveRecord::Migration
  def self.up
    add_index :images, [:imageable_id, :imageable_type]
  end

  def self.down
    remove_index :images, [:imageable_id, :imageable_type]
  end
end
