class CreateUnits < ActiveRecord::Migration
  def self.up
    create_table :units do |t|
      t.string  :type,         :default => '',   :null => false
      t.boolean :occupied,     :default => true, :null => false
      t.string  :name,         :default => '',   :null => false
      t.decimal :rent_min,     :default => 0,    :null => false
      t.decimal :rent_max,     :default => 0,    :null => false
      t.integer :entry_floor,  :default => 0,    :null => false
      t.integer :area_min,     :default => 0,    :null => false
      t.integer :area_max,     :default => 0,    :null => false
      t.string  :gables_id,    :default => '',   :null => false

      t.timestamps

      t.belongs_to :floorplan
    end

    add_index :units, :gables_id, :unique => true
  end

  def self.down
    remove_index :units, :gables_id
    drop_table :units
  end
end
