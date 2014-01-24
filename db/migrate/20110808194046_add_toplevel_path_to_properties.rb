class AddToplevelPathToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :path, :string, :null => false, :default => ""
  end

  def self.down
    remove_column :properties, :path
  end
end
