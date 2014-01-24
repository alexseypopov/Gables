class AddNotesFieldsToTabletGuest < ActiveRecord::Migration
  def self.up
    change_table :tablet_guests do |t|
      t.text :notes_likes
      t.text :notes_dislikes
      t.text :notes_remarks
      t.text :notes_hotbuttons
    end
  end

  def self.down
    change_table :tablet_guests do |t|
      t.remove :notes_likes
      t.remove :notes_dislikes
      t.remove :notes_remarks
      t.remove :notes_hotbuttons
    end
  end
end
