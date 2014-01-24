class AddBuildingNumberToUnit < ActiveRecord::Migration
  def self.up
    add_column :units, :building_name, :string, :default => "", :null => false
  end

  def self.down
    remove_column :units, :building_name
  end
end
