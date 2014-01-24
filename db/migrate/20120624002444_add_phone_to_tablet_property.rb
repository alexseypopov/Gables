class AddPhoneToTabletProperty < ActiveRecord::Migration
  def self.up
    add_column :tablet_properties, :phone, :string
  end

  def self.down
    remove_column :tablet_properties, :phone
  end
end
