class CreateTabletLeadSources < ActiveRecord::Migration
  def self.up
    create_table :tablet_lead_sources, :id => false do |t|
      t.integer :id
      t.references :tablet_property
      t.string :name
    end
    add_index :tablet_lead_sources, [:tablet_property_id, :id], :unique => true
  end

  def self.down
    drop_table :tablet_lead_sources
  end
end
