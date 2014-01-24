class AddPetPoliciesToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :dog_policy, :text, :null => false, :default => ""
    add_column :properties, :cat_policy, :text, :null => false, :default => ""
  end

  def self.down
    remove_column :properties, :dog_policy
    remove_column :properties, :cat_policy
  end
end
