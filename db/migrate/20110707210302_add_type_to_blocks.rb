class AddTypeToBlocks < ActiveRecord::Migration
  def self.up
    add_column :blocks, :type, :string, :default => "Block"
  end

  def self.down
    remove_column :blocks, :type
  end
end
