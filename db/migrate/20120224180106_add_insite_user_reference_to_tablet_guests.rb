class AddInsiteUserReferenceToTabletGuests < ActiveRecord::Migration
  def self.up
    add_column :tablet_guests, :tablet_insite_user_id, :integer
  end

  def self.down
    drop_column :tablet_guests, :tablet_insite_user_id
  end
end
