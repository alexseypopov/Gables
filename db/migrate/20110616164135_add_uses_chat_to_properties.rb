class AddUsesChatToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :uses_chat, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :properties, :uses_chat
  end
end
