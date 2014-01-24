class AddGooglePlaceDataToProperty < ActiveRecord::Migration
  def self.up
  	add_column :properties, :google_place_data, :text
  end

  def self.down
  	drop_column :properties, :google_place_data
  end
end
