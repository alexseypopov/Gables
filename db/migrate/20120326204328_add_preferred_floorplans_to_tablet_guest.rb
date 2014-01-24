class AddPreferredFloorplansToTabletGuest < ActiveRecord::Migration
  def self.up
    add_column :tablet_guests, :preferred_floorplans, :text
  end

  def self.down
    remove_column :tablet_guests, :guest_names
  end
end
