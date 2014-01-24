class CreateGcaPropertyRegions < ActiveRecord::Migration
  def self.up
    create_table :gca_property_regions do |t|
      t.integer :property_id
      t.integer :region_id
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :gca_property_regions
  end
end
