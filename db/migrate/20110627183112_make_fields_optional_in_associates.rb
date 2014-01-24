class MakeFieldsOptionalInAssociates < ActiveRecord::Migration
  def self.up
    change_column :associates, :description,  :text, :null => true
    change_column :associates, :story,        :text, :null => true
    change_column :associates, :work,         :text, :null => true
    change_column :associates, :career_path,  :text, :null => true
  end

  def self.down
    change_column :associates, :description,  :text, :null => false, :default => ""
    change_column :associates, :story,        :text, :null => false, :default => ""
    change_column :associates, :work,         :text, :null => false, :default => ""
    change_column :associates, :career_path,  :text, :null => false, :default => ""
  end
end
