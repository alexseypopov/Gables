class AddIndexesForPerformance < ActiveRecord::Migration
  def up
    add_index :amenities_floorplans, :amenity_id
    add_index :amenities_floorplans, :floorplan_id
    add_index :amenities_properties, :amenity_id
    add_index :amenities_properties, :property_id
    add_index :amenities_units, :amenity_id
    add_index :amenities_units, :unit_id
    add_index :floorplans, :property_id
    add_index :amenities, :description
  end

  def down
    remove_index :amenities_floorplans, :amenity_id
    remove_index :amenities_floorplans, :floorplan_id
    remove_index :amenities_properties, :amenity_id
    remove_index :amenities_properties, :property_id
    remove_index :amenities_units, :amenity_id
    remove_index :amenities_units, :unit_id
    remove_index :floorplans, :property_id
    remove_index :amenities, :description
  end
end
