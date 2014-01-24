class CreateGcaRegions < ActiveRecord::Migration
  def self.up
    create_table :gca_regions do |t|
      t.string :city
      t.string :state

      t.timestamps
    end
  end

  def self.down
    drop_table :gca_regions
  end
end
