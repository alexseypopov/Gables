class CreateSpecials < ActiveRecord::Migration
  def self.up
    create_table :specials do |t|
      t.text  :header, :default => '', :null => false
      t.text  :body,   :default => '', :null => false

      t.timestamps

      t.belongs_to :floorplan
      t.belongs_to :property
      t.belongs_to :unit
    end
  end

  def self.down
    drop_table :specials
  end
end
