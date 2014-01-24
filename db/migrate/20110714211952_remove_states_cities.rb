class RemoveStatesCities < ActiveRecord::Migration
  def self.up
    drop_table :states
    drop_table :cities
    remove_column :regions, :city_id
  end

  def self.down
    create_table :states do |t|
      t.string  :name, :null => false, :default => ""

      t.timestamps
    end

    create_table :cities do |t|
      t.string  :name,    :null => false, :default => ""
      t.integer :state_id

      t.timestamps
    end

    add_column :regions, :city_id, :integer
  end
end
