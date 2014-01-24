class CreateHomeSlides < ActiveRecord::Migration
  def self.up
    create_table :home_slides do |t|
      t.string  :image
      t.string  :paragraph1, :null => false, :default => ""
      t.string  :paragraph2, :null => false, :default => ""
      t.text    :paragraph3, :null => false, :default => ""

      t.timestamps
    end
  end

  def self.down
    drop_table :home_slides
  end
end
