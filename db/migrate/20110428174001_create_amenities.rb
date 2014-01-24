class CreateAmenities < ActiveRecord::Migration
  def self.up
    create_table :amenities do |t|
      t.string  :description, :default => '', :null => false
      t.integer :rank,        :default => 0,  :null => false

      t.timestamps
    end

    create_table :amenities_floorplans, :id => false do |t|
      t.integer :amenity_id
      t.integer :floorplan_id
    end

    create_table :amenities_properties, :id => false do |t|
      t.integer :amenity_id
      t.integer :property_id
    end

    create_table :amenities_units, :id => false do |t|
      t.integer :amenity_id
      t.integer :unit_id
    end
  end

  def self.down
    drop_table :amenities
    drop_table :amenities_floorplans
    drop_table :amenities_properties
    drop_table :amenities_units
  end
end
