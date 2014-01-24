class AddGoogleIdToProperty < ActiveRecord::Migration
  def self.up
    add_column :properties, :google_id, :string
  end

  def self.down
    remove_column :properties, :google_id, :string
  end
end
