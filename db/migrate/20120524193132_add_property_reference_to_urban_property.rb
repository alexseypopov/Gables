class AddPropertyReferenceToUrbanProperty < ActiveRecord::Migration
  def self.up
    change_table :urban_properties do |t|
      t.references :property
    end
  end

  def self.down
    change_table :urban_properties do |t|
      t.remove :property
    end
  end
end
