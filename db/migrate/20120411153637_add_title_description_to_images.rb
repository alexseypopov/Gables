class AddTitleDescriptionToImages < ActiveRecord::Migration
  def self.up
    change_table :images do |t|
      t.string :name
      t.string :description
    end
  end

  def self.down
    change_table :images do |t|
      t.remove :name
      t.remove :description
    end
  end
end
