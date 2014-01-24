class AddPetPolicyToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :pet_policy, :text, :default => ""
  end

  def self.down
    remove_column :properties, :pet_policy
  end
end
