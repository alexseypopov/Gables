class AddAdministersFieldsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :administers_residential,  :boolean, :default => false, :null => false
    add_column :users, :administers_gca,          :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :users, :administers_residential
    remove_column :users, :administers_gca
  end
end
