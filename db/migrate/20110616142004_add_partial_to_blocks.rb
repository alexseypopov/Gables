class AddPartialToBlocks < ActiveRecord::Migration
  def self.up
    add_column :blocks, :partial, :string, :null => false, :default => '_default.html.haml'
  end

  def self.down
    remove_column :blocks, :partial
  end
end
