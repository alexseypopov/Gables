class RenameParagraphColumnsInHomeSlides < ActiveRecord::Migration
  def self.up
    remove_column :home_slides, :paragraph1
    remove_column :home_slides, :paragraph2
    remove_column :home_slides, :paragraph3
    add_column    :home_slides, :title,       :string,  :null => false, :default => ""
    add_column    :home_slides, :subtitle,    :string,  :null => false, :default => ""
    add_column    :home_slides, :description, :text,    :null => false, :default => ""
  end

  def self.down
    add_column    :home_slides, "paragraph1", :string,  :null => false, :default => ""
    add_column    :home_slides, "paragraph2", :string,  :null => false, :default => ""
    add_column    :home_slides, "paragraph3", :text,    :null => false, :default => ""
    remove_column :home_slides, :title
    remove_column :home_slides, :subtitle
    remove_column :home_slides, :description
  end
end
