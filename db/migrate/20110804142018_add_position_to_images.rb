class AddPositionToImages < ActiveRecord::Migration
  def self.up
    add_column :images, :position, :integer, :default => 0, :null => false
  end

  def self.down
    remove_column :images, :position
  end
end
