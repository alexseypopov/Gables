class AddInsiteFieldsToGuest < ActiveRecord::Migration
  def self.up
    change_table :tablet_guests do |t|
      t.string  :property_name
      t.integer :insite_id
      t.string  :status
    end
  end

  def self.down
    change_table :tablet_guests do |t|
      t.remove :property_name
      t.remove :insite_id
      t.remove :status
    end
  end
end
