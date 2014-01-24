class AddAddress2ToProperty < ActiveRecord::Migration
  def self.up
    add_column :properties, :address2, :string
  end

  def self.down
    remove_column :properties, :address2
  end
end
