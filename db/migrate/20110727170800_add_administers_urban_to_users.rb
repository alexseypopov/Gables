class AddAdministersUrbanToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, "administers_urban", :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :users, "administers_urban"
  end
end
