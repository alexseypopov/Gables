class AddFloorplanIndexToUnits < ActiveRecord::Migration
  def self.up
    add_index :units, :floorplan_id
  end
  def self.down
    remove_index :units, :floorplan_id
  end
end
