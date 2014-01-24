class RenameBlocksToPageBlocks < ActiveRecord::Migration
  def self.up
    rename_table :blocks, :page_blocks
    rename_column :page_main_blocks, :block_id, :page_block_id
    rename_column :page_side_blocks, :block_id, :page_block_id
  end

  def self.down
    rename_column :page_main_blocks, :page_block_id, :block_id
    rename_column :page_side_blocks, :page_block_id, :block_id
    rename_table :page_blocks, :blocks
  end
end
