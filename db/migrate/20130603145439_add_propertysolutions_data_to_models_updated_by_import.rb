class AddPropertysolutionsDataToModelsUpdatedByImport < ActiveRecord::Migration
  def up
    [:properties, :floorplans, :units, :amenities, :specials, :images].each do |table_name|
      add_column table_name, :propertysolutions_data, :text
      add_column table_name, :vaultware_data, :text
    end
  end

  def down
    [:properties, :floorplans, :units, :amenities, :specials, :images].each do |table_name|
      remove_column table_name, :propertysolutions_data
      remove_column table_name, :vaultware_data
    end
  end
end
