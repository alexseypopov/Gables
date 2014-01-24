class AddDisabledReferredToTabletGuest < ActiveRecord::Migration
  def self.up
    add_column :tablet_guests, :referrer_disabled, :boolean
  end

  def self.down
    remove_column :tablet_guests, :referrer_disabled
  end
end
