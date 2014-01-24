class MakeAreaMaxesOptional < ActiveRecord::Migration
  def self.up
    change_column :floorplans,  "area_max", :integer, :default => 0, :null => true
    change_column :units,       "area_max", :integer, :default => 0, :null => true
  end

  def self.down
    change_column :floorplans, "area_max", :integer, :default => 0, :null => false
    change_column :units,      "area_max", :integer, :default => 0, :null => false
  end
end
