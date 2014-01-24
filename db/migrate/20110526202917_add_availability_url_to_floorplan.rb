class AddAvailabilityUrlToFloorplan < ActiveRecord::Migration
  def self.up
    add_column :floorplans, :availability_url, :text, :default => "", :null => false 
  end

  def self.down
    remove_column :floorplans, :availability_url
  end
end
