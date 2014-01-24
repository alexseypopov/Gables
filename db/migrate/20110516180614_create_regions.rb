class CreateRegions < ActiveRecord::Migration
  def self.up
    create_table :regions do |t|
      t.string  :name, :default => "", :null => false
      t.timestamps
    end

    add_index :regions, :name, :unique => true    

    add_column :properties, :region_id, :integer
  end

  def self.down
    drop_table :regions
    remove_column :properties, :region_id
  end
end
