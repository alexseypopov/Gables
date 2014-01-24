class CreateGreenCategories < ActiveRecord::Migration
  def self.up
    create_table :green_categories do |t|
      t.string :name
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :green_categories
  end
end
