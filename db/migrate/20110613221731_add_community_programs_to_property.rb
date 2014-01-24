class AddCommunityProgramsToProperty < ActiveRecord::Migration
  def self.up
    add_column :properties, :community_programs, :text, :null => false, :default => ""
  end

  def self.down
    remove_column :properties, :community_programs
  end
end
