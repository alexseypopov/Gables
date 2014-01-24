class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.boolean :published,   :null => false, :default => true
      t.string :path,         :null => false, :default => ""
      t.string :subtitle,     :null => false, :default => ""
      t.string :title,        :null => false, :default => ""
      t.string :name,         :null => false, :default => ""
      t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
