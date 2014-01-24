class CreateSearchAmenities < ActiveRecord::Migration
  def self.up
    create_table :search_amenities do |t|
      t.string  :description, :default => '', :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :search_amenities
  end
end
