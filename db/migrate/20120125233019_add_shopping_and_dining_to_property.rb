class AddShoppingAndDiningToProperty < ActiveRecord::Migration
  def self.up
    add_column :properties, :shopping_and_dining, :text
  end

  def self.down
    remove_column :properties, :shopping_and_dining
  end
end
