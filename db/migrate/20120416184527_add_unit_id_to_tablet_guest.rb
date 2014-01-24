class AddUnitIdToTabletGuest < ActiveRecord::Migration
  def self.up
    add_column :tablet_guests, :unit_id, :integer
  end

  def self.down
    remove_column :tablet_guests, :unit_id
  end
end
