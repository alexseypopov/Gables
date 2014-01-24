class AddEmailOptinToTabletGuest < ActiveRecord::Migration
  def self.up
    add_column :tablet_guests, :email_optin, :boolean
  end

  def self.down
    remove_column :tablet_guests, :email_optin
  end
end
