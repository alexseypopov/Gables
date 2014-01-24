class AddCalendarUrlToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :calendar_url, :text
  end

  def self.down
    remove_column :properties, :calendar_url
  end
end
