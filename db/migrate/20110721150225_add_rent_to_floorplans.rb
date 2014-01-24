class AddRentToFloorplans < ActiveRecord::Migration
  def self.up
    add_column :floorplans, :rent_min, :decimal, :null => false, :default => 0
    add_column :floorplans, :rent_max, :decimal, :null => false, :default => 0
  end

  def self.down
    remove_column :floorplans, :rent_min
    remove_column :floorplans, :rent_max
  end
end
