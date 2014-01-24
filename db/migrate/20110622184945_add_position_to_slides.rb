class AddPositionToSlides < ActiveRecord::Migration
  def self.up
    add_column :home_slides, :position, :integer, :null => false, :default => 0
    add_column :life_slides, :position, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :home_slides, :position
    remove_column :life_slides, :position
  end
end
