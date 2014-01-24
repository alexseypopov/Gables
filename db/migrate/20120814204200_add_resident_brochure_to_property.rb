class AddResidentBrochureToProperty < ActiveRecord::Migration
  def self.up
    change_table :properties do |t|
      t.string :resident_brochure
    end
  end

  def self.down
    change_table :properties do |t|
      t.remove :resident_brochure
    end
  end
end
