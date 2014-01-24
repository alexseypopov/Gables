class AddDefaultAvailableOnToUnits < ActiveRecord::Migration
  def self.up
    change_column :units, :available_on, :date, :null => false, :default => '2011-01-01'
  end

  def self.down
    # nothing
  end
end
