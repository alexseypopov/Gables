class AddFeaturedToAssociates < ActiveRecord::Migration
  def self.up
    add_column :associates, :featured, :boolean, :default => false
  end

  def self.down
    remove_column :associates, :featured
  end
end
