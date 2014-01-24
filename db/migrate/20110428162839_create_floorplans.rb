class CreateFloorplans < ActiveRecord::Migration
  def self.up
    create_table :floorplans do |t|
      t.decimal :bedrooms_count ,   :default => 0,   :null => false
      t.decimal :bathrooms_count ,  :default => 0,   :null => false  # e.g. 1.5
      t.string  :name,              :default => '',  :null => false
      t.text    :image_urls,        :default => '',  :null => false 
      t.integer :area_min,          :default => 0,   :null => false
      t.integer :area_max,          :default => 0,   :null => false
      t.string  :gables_id,         :default => '',  :null => false
      

      t.timestamps
      
      t.belongs_to :property
    end

    add_index :floorplans, :gables_id, :unique => true
  end

  def self.down
    remove_index :floorplans, :gables_id, :unique => true
    drop_table :floorplans
  end
end
