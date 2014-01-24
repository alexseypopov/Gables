class AddSorPolicyToProperty < ActiveRecord::Migration
  def self.up
    change_table :properties do |t|
      t.string :sor_policy
      t.string :lease_briefs
    end
  end

  def self.down
    change_table :properties do |t|
      t.remove :sor_policy
      t.string :lease_briefs
    end
  end
end
