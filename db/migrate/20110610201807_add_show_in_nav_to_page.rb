class AddShowInNavToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :show_in_nav, :boolean, :null => false, :default => true
  end

  def self.down
    remove_column :pages, :show_in_nav
  end
end
