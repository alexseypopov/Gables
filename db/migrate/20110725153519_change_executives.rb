class ChangeExecutives < ActiveRecord::Migration
  def self.up
    change_column :executives, :category, :string,  :null => false, :default => 'Company Officer'
    add_column    :executives, :position, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :executives, :position
  end
end
