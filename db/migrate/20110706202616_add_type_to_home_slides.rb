class AddTypeToHomeSlides < ActiveRecord::Migration
  def self.up
    add_column :home_slides, :type, :string, :default => "HomeSlide"
  end

  def self.down
    remove_column :home_slides, :type
  end
end
