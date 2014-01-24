class ChangeDecimalToFloatInFloorplans < ActiveRecord::Migration
  def self.up
    change_column :floorplans, :bathrooms_count, :decimal, :default => 0.0, :null => false, :precision => 3, :scale => 1
  end

  def self.down
    #nothing
  end
end
