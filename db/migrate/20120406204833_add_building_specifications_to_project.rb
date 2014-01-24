class AddBuildingSpecificationsToProject < ActiveRecord::Migration
  def self.up
    change_table :properties do |t|
      t.text   :building_specifications
      t.string :building_specifications_file
    end
  end

  def self.down
    change_table :properties do |t|
      t.remove :building_specifications
      t.remove :building_specifications_file
    end
  end
end
