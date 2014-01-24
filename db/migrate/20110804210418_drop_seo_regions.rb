class DropSeoRegions < ActiveRecord::Migration
  def self.up
    drop_table :properties_seo_regions
    drop_table :seo_regions
  end

  def self.down
    create_table :seo_regions do |t|
      t.float   :latitude,    :default => 0.0,  :null => false
      t.float   :longitude,   :default => 0.0,  :null => false
      t.string  :name,        :default => "",   :null => false
      t.text    :description, :default => ""

      t.timestamps
    end

    create_table :properties_seo_regions, :id => false do |t|
      t.integer :property_id
      t.integer :seo_region_id
    end
  end
end
