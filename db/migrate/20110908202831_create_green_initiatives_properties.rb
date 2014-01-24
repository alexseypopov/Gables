class CreateGreenInitiativesProperties < ActiveRecord::Migration
  def self.up
    create_table :green_initiatives_properties, :id => false do |t|
      t.integer :green_initiative_id
      t.integer :property_id

      t.timestamps
    end
  end

  def self.down
    drop_table :green_initiatives_properties
  end
end
