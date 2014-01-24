class RemoveImageUrls < ActiveRecord::Migration
  def self.up
    remove_column :properties, :image_urls
    remove_column :floorplans, :image_urls
  end

  def self.down
    add_column :properties, :image_urls, :string
    add_column :floorplans, :image_urls, :string
  end
end
