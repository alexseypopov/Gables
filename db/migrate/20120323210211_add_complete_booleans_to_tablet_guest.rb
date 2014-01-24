class AddCompleteBooleansToTabletGuest < ActiveRecord::Migration
  def self.up
    change_table :tablet_guests do |t|
      t.boolean :add_prospect_complete
      t.boolean :select_apartments_complete
      t.boolean :gather_licenses_complete
      t.boolean :gables_difference_complete
      t.boolean :return_licenses_complete
      t.boolean :take_homes_complete
      t.boolean :notes_complete
      t.boolean :thank_you_note_complete
      t.boolean :invite_to_apply_complete
    end
  end

  def self.down
    change_table :tablet_guests do |t|
      t.remove :add_prospect_complete
      t.remove :select_apartments_complete
      t.remove :gather_licenses_complete
      t.remove :gables_difference_complete
      t.remove :return_licenses_complete
      t.remove :take_homes_complete
      t.remove :notes_complete
      t.remove :thank_you_note_complete
      t.remove :invite_to_apply_complete
    end
  end
end
