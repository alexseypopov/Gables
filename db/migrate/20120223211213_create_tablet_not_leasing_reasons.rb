class CreateTabletNotLeasingReasons < ActiveRecord::Migration
  def self.up
    create_table :tablet_not_leasing_reasons do |t|
      t.string :name
    end
  end

  def self.down
    drop_table :tablet_not_leasing_reasons
  end
end
