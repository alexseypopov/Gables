class AddInactiveFlagToTabletGuest < ActiveRecord::Migration
  def self.up
    add_column :tablet_guests, :inactive, :boolean
  end

  def self.down
    remove_column :tablet_guests, :inactive
  end
end
