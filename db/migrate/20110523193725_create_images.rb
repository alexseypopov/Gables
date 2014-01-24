class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.boolean     :from_vaultware,  :default => false,  :null => false
      t.string      :vaultware_url,   :default => '',      :null => false
      t.string      :image
      t.references  :imageable, :polymorphic => true

      t.timestamps
    end
  end

  def self.down
    drop_table :images
  end
end
