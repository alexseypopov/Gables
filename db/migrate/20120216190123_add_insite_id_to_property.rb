class AddInsiteIdToProperty < ActiveRecord::Migration
  def self.up
    add_column :properties, :insite_id, :integer
    add_index  :properties, :insite_id
  end

  def self.down
    remove_column :properties, :insite_id
  end
end
