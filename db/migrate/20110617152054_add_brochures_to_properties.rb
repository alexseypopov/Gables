class AddBrochuresToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :full_brochure, :string
    add_column :properties, :short_brochure, :string
  end

  def self.down
    remove_column :properties, :full_brochure
    remove_column :properties, :short_brochure
  end
end
