class CreateUrbanImages < ActiveRecord::Migration
  def self.up
    create_table :urban_images do |t|
      t.string   "image"
      t.integer  "property_id"
      t.integer  "position",       :default => 0,     :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :urban_images
  end
end
