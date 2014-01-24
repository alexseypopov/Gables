class MakeFieldsOptionalInProperties < ActiveRecord::Migration
  def self.up
    change_column :properties, :cat_policy,         :text, :default => "", :null => true
    change_column :properties, :dog_policy,         :text, :default => "", :null => true
    change_column :properties, :community_programs, :text, :default => "", :null => true
  end

  def self.down
    # nothing
  end
end
