class RemoveGreenInitiativesFromProperty < ActiveRecord::Migration
  def self.up
    remove_column :properties, :green_initiatives
  end

  def self.down
    add_column :properties, :green_initiatives, :string
  end
end
