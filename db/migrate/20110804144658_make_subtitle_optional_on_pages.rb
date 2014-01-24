class MakeSubtitleOptionalOnPages < ActiveRecord::Migration
  def self.up
    change_column :pages, "subtitle", :string, :default => "", :null => true
  end

  def self.down
    #nothing
  end
end
