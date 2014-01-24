class AddForSeoToRegions < ActiveRecord::Migration
  def self.up
    add_column :regions, :for_seo, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :regions, :for_seo
  end
end
