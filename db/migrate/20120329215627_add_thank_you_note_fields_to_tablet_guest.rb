class AddThankYouNoteFieldsToTabletGuest < ActiveRecord::Migration
  def self.up
    change_table :tablet_guests do |t|
      t.boolean :follow_up_required
      t.date    :follow_up_date
      t.text    :not_leasing_reason_details
    end
  end

  def self.down
    change_table :tablet_guests do |t|
      t.remove :follow_up_required
      t.remove :follow_up_date
      t.remove :not_leasing_reason_details
    end
  end
end
