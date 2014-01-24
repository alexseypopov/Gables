class RenameTabletGuestLeadSourceReference < ActiveRecord::Migration
  def self.up
    rename_column :tablet_guests, :tablet_lead_sources_id, :tablet_lead_source_id
  end

  def self.down
    rename_column :tablet_guests, :tablet_lead_source_id, :tablet_lead_sources_id
  end
end
