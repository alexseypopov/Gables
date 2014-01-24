class AddUsePropertysolutionsDataFlagToProperties < ActiveRecord::Migration
  def up
    [:properties, :floorplans, :units, :amenities, :specials, :images].each do |table_name|
      add_column table_name, :use_propertysolutions_data, :boolean, :default => false
    end
  end

  def down
    [:properties, :floorplans, :units, :amenities, :specials, :images].each do |table_name|
      remove_column table_name, :use_propertysolutions_data
    end
  end
end
