class CreateTabletGuests < ActiveRecord::Migration
  def self.up
    create_table :tablet_guests do |t|
      t.string :first_name
      t.string :last_name
      t.string :middle_initial
      t.string :home_phone
      t.string :work_phone
      t.string :cell_phone
      t.string :email
      t.string :address_line1
      t.string :address_line2
      t.string :city
      t.string :state
      t.string :zip
      t.string :employer_name
      t.string :employer_address_line1
      t.string :employer_address_line2
      t.string :employer_zip
      t.string :referral_name
      t.string :referral_fee
      t.boolean :escorted
      t.datetime :move_in_date
      t.string :preferred_unit_type1
      t.string :preferred_unit_type2
      t.integer :num_occupants
      t.text :notes
      t.text :apartment_needs
      t.boolean :pets
      t.boolean :furnished

      t.references :tablet_rent_range
      t.references :tablet_leasing_reason
      t.references :tablet_not_leasing_reason
      t.references :tablet_lead_sources
      t.references :tablet_property
      t.timestamps
    end
  end

  def self.down
    drop_table :tablet_guests
  end
end
