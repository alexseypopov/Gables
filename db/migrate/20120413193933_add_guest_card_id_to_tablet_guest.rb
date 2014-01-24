class AddGuestCardIdToTabletGuest < ActiveRecord::Migration
  def self.up
    add_column :tablet_guests, :guest_card_id, :integer
  end

  def self.down
    remove_column :tablet_guests, :guest_card_id
  end
end
