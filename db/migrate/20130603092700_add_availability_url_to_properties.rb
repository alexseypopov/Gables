class AddAvailabilityUrlToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :availability_url, :string
  end
end
