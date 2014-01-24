class AddTypeToSearchAmenities < ActiveRecord::Migration
  def self.up
    add_column :search_amenities, :type, :string
  end

  def self.down
    remove_column :search_amenities, :type
  end
end
