class CreateBlocks < ActiveRecord::Migration
  def self.up
    create_table :blocks do |t|
      t.boolean	:editable,	:null => false, :default => true
      t.string	:title,	    :null => false, :default => ""
      t.text		:content,	  :null => false, :default => ""

      t.timestamps
    end
  end

  def self.down
    drop_table :blocks
  end
end
