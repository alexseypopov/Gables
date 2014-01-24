class AllowNullDescriptionInHomeSlides < ActiveRecord::Migration
  def self.up
    change_column :home_slides, :description, :text, :null => true
  end

  def self.down
    change_column :home_slides, :description, :text, :null => false, :default => ""
  end
end
