class AddPositionToUrbanProperties < ActiveRecord::Migration
  def self.up
    add_column :urban_properties, :position, :integer
  end

  def self.down
    remove_column :urban_properties, :position
  end
end
