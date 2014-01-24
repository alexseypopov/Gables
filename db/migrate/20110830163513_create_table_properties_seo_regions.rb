class CreateTablePropertiesSeoRegions < ActiveRecord::Migration
  def self.up
    create_table :properties_seo_regions, :id => false do |t|
      t.references :property, :seo_region
    end
  end

  def self.down
    drop_table :properties_seo_regions
  end
end
