class CreateProperties < ActiveRecord::Migration
  def self.up
    create_table :properties do |t|
      t.boolean :allows_dogs,       :default => false, :null => false
      t.boolean :allows_cats,       :default => false, :null => false
      t.text    :short_description, :default => '',    :null => false
      t.text    :long_description,  :default => '',    :null => false
      t.string  :name,              :default => '',    :null => false
      t.text    :image_urls,        :default => '',    :null => false
      t.string  :phone,             :default => '',    :null => false
      t.string  :street,            :default => '',    :null => false
      t.string  :city,              :default => '',    :null => false
      t.string  :state,             :default => '',    :null => false
      t.string  :zip,               :default => '',    :null => false
      t.text    :office_hours,      :default => '',    :null => false
      t.boolean :from_vaultware,    :default => false, :null => false
      t.string  :gables_id,         :default => '',    :null => false

      t.timestamps
    end

    add_index :properties, :gables_id, :unique => true
  end

  def self.down
    remove_index :properties, :gables_id
    drop_table :properties
  end
end
