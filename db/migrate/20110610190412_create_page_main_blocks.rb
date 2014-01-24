class CreatePageMainBlocks < ActiveRecord::Migration
  def self.up
    create_table :page_main_blocks do |t|
      t.integer :position, :null => false, :default => 0
      t.integer :page_id
      t.integer :block_id

      t.timestamps
    end

    add_index :page_main_blocks, [:page_id, :block_id]
  end

  def self.down
    drop_table :page_main_blocks
  end
end
