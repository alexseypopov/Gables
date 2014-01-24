class AddLatLngToProperty < ActiveRecord::Migration
  def self.up
    add_column :properties, :latitude, :float, :default => 0.0, :null => false
    add_column :properties, :longitude, :float, :default => 0.0, :null => false
  end

  def self.down
    remove_column :properties, :latitude
    remove_column :properties, :longitude
  end
end
