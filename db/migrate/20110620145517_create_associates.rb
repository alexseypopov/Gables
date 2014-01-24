class CreateAssociates < ActiveRecord::Migration
  def self.up
    create_table :associates do |t|
      t.string  :name,        :null => false, :default => ""
      t.string  :title,       :null => false, :default => ""
      t.text    :description, :null => false, :default => ""
      t.string  :image,       :null => false, :default => ""
      t.text    :story,       :null => false, :default => ""
      t.text    :work,        :null => false, :default => ""
      t.text    :career_path, :null => false, :default => ""

      t.timestamps
    end
  end

  def self.down
    drop_table :associates
  end
end
