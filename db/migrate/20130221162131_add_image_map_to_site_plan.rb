class AddImageMapToSitePlan < ActiveRecord::Migration
  def self.up
    add_column :site_plans, :image_map, :text
  end

  def self.down
    remove_column :site_plans, :image_map
  end
end
