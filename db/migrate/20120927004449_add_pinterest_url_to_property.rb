class AddPinterestUrlToProperty < ActiveRecord::Migration
  def self.up
    add_column :properties, :pinterest_url, :string
  end

  def self.down
    drop_column :properties, :pinterest_url
  end
end
