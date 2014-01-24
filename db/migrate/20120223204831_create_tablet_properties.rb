class CreateTabletProperties < ActiveRecord::Migration
  def self.up
    create_table :tablet_properties do |t|
      t.string :name
      t.string :email
      t.integer :vaultware_id
    end
  end

  def self.down
    drop_table :tablet_properties
  end
end
