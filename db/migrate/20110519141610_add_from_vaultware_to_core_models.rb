class AddFromVaultwareToCoreModels < ActiveRecord::Migration
  def self.up
    add_column :amenities,  :from_vaultware, :boolean, :default => false, :null => false
    add_column :floorplans, :from_vaultware, :boolean, :default => false, :null => false
    add_column :specials,   :from_vaultware, :boolean, :default => false, :null => false
    add_column :units,      :from_vaultware, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :amenities,   :from_vaultware
    remove_column :floorplans,  :from_vaultware
    remove_column :specials,    :from_vaultware
    remove_column :units,       :from_vaultware
  end
end
