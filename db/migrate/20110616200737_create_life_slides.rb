class CreateLifeSlides < ActiveRecord::Migration
  def self.up
    create_table :life_slides do |t|
      t.string  :image

      t.timestamps
    end
  end

  def self.down
    drop_table :life_slides
  end
end
