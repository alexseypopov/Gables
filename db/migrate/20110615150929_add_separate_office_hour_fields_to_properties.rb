class AddSeparateOfficeHourFieldsToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :monday_hours,    :string, :null => false, :default => ""
    add_column :properties, :tuesday_hours,   :string, :null => false, :default => ""
    add_column :properties, :wednesday_hours, :string, :null => false, :default => ""
    add_column :properties, :thursday_hours,  :string, :null => false, :default => ""
    add_column :properties, :friday_hours,    :string, :null => false, :default => ""
    add_column :properties, :saturday_hours,  :string, :null => false, :default => ""
    add_column :properties, :sunday_hours,    :string, :null => false, :default => ""

    remove_column :properties, :office_hours
  end

  def self.down
    add_column    :properties, :office_hours, :text, :null => false

    remove_column :properties, :monday_hours
    remove_column :properties, :tuesday_hours
    remove_column :properties, :wednesday_hours
    remove_column :properties, :thursday_hours
    remove_column :properties, :friday_hours
    remove_column :properties, :saturday_hours
    remove_column :properties, :sunday_hours
  end
end
