class AddDescriptionToRegions < ActiveRecord::Migration
  def self.up
    add_column :regions, :description, :text, :null => false, :default => ""
  end

  def self.down
    remove_column :regions, :description
  end
end
