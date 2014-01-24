class AddBrochuresToTabletGuest < ActiveRecord::Migration
  def self.up
    change_table :tablet_guests do |t|
      t.boolean :community_brochure
      t.boolean :floorplan_brochure
      t.boolean :building_specifications
    end
  end

  def self.down
    change_table :tablet_guests do |t|
      t.remove :community_brochure
      t.remove :floorplan_brochure
      t.remove :building_specifications
    end
  end
end
