class MakeSpecialsPolymorphic < ActiveRecord::Migration
  def self.up
    remove_column :specials, :unit_id
    remove_column :specials, :floorplan_id
    remove_column :specials, :property_id
    add_column    :specials, :specialable_id,   :integer
    add_column    :specials, :specialable_type, :string
  end

  def self.down
    add_column :specials, :unit_id,       :integer
    add_column :specials, :floorplan_id,  :integer
    add_column :specials, :property_id,   :integer
    remove_column    :specials, :specialable_id
    remove_column    :specials, :specialable_type
  end
end
