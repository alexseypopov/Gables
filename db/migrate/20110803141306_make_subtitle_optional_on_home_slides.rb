class MakeSubtitleOptionalOnHomeSlides < ActiveRecord::Migration
  def self.up
    change_column :home_slides, :subtitle, :string, :default => '', :null => true
  end

  def self.down
    # nothing
  end
end
