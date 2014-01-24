class CreateGreenInitiatives < ActiveRecord::Migration
  def self.up
    create_table :green_initiatives do |t|
      t.string :name
      t.integer :green_category_id

      t.timestamps
    end
  end

  def self.down
    drop_table :green_initiatives
  end
end
