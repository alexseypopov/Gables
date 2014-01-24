class AddCategoryToExecutives < ActiveRecord::Migration
  def self.up
    add_column :executives, :category, :string, :default => 'Management Team', :null => false
  end

  def self.down
    remove_column :executives, :category
  end
end
