class AddAvailabilityUrlToUnit < ActiveRecord::Migration
  def self.up
    add_column :units, :availability_url, :text, :default => "", :null => false 
  end

  def self.down
    remove_column :units, :availability_url
  end
end
