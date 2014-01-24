class AddAvailableDateToUnits < ActiveRecord::Migration
  def self.up
    add_column :units, :available_on, :date, :null => false
  end

  def self.down
    remove_column :units, :available_on
  end
end
