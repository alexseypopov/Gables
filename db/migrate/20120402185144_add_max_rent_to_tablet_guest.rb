class AddMaxRentToTabletGuest < ActiveRecord::Migration
  def self.up
    add_column :tablet_guests, :max_rent, :integer
  end

  def self.down
    remove_column :tablet_guests, :max_rent
  end
end
