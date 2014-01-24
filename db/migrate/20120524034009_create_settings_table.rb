class CreateSettingsTable < ActiveRecord::Migration
  def self.up
    create_table :settings do |table|
      table.string :key
      table.string :value
    end
    add_index :settings, :key
  end

  def self.down
    drop_table :settings
  end
end
