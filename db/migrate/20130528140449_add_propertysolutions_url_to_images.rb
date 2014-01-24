class AddPropertysolutionsUrlToImages < ActiveRecord::Migration
  def change
    add_column :images, :propertysolutions_url, :string
  end
end
