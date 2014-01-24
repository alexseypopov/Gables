class ChangeBlockPartialDefault < ActiveRecord::Migration
  def self.up
    change_column :blocks, :partial, :string, :null => false, :default => 'default'
  end

  def self.down
    # nothing
  end
end
