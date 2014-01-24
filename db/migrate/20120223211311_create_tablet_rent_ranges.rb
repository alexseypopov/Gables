class CreateTabletRentRanges < ActiveRecord::Migration
  def self.up
    create_table :tablet_rent_ranges do |t|
      t.string :name
    end
  end

  def self.down
    drop_table :tablet_rent_ranges
  end
end
