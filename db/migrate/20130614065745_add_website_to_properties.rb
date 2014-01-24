class AddWebsiteToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :website, :string
  end
end
