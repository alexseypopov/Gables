class AddFieldsToTabletProperty < ActiveRecord::Migration
  def self.up
    change_table(:tablet_properties) do |t|
      t.string :community_manager
      t.string :community_manager_email
      t.string :regional_manager
      t.string :regional_manager_email
      t.string :state
      t.remove :email
    end
  end

  def self.down
    change_table(:tablet_properties) do |t|
      t.remove :community_manager
      t.remove :community_manager_email
      t.remove :regional_manager
      t.remove :regional_manager_email
      t.remove :state
      t.string :email
    end
  end
end
