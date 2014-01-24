class CreateSeoRegions < ActiveRecord::Migration
  def self.up
    create_table :seo_regions do |t|
      t.integer :region_id

      t.timestamps
    end
  end

  def self.down
    drop_table :seo_regions
  end
end
