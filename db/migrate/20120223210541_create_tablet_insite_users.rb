class CreateTabletInsiteUsers < ActiveRecord::Migration
  def self.up
    create_table :tablet_insite_users do |t|
      t.string :user_id
      t.string :name
      t.string :email
    end
  end

  def self.down
    drop_table :tablet_insite_users
  end
end
