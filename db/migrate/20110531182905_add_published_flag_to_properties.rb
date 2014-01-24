class AddPublishedFlagToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :published, :boolean, :null => false, :default => true
  end

  def self.down
    remove_column :properties, :published
  end
end
