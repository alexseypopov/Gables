class AddLatLngToRegion < ActiveRecord::Migration
  def self.up
    add_column :regions, :latitude, :float, :default => 0.0, :null => false
    add_column :regions, :longitude, :float, :default => 0.0, :null => false
  end

  def self.down
    remove_column :regions, :latitude
    remove_column :regions, :longitude
  end
end
