class CreateGcaPromos < ActiveRecord::Migration
  def self.up
    create_table :gca_promos do |t|
      t.string  :heading, :null => false, :default => ''
      t.text    :text
      t.string  :link
      t.string  :image
      t.integer :position, :null => false, :default => 0
      t.string  :video_id
      t.timestamps
    end
  end

  def self.down
    drop_table :gca_promos
  end
end
