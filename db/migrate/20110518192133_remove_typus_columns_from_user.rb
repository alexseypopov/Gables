class RemoveTypusColumnsFromUser < ActiveRecord::Migration
  def self.up
    remove_column :users, "first_name"
    remove_column :users, "last_name"
    remove_column :users, "role"
    remove_column :users, "status"
    remove_column :users, "token"
    remove_column :users, "salt"
    remove_column :users, "crypted_password"
    remove_column :users, "preferences"
  end

  def self.down
    change_table "users" do |t|
      t.string   "first_name",                            :default => "",    :null => false
      t.string   "last_name",                             :default => "",    :null => false
      t.string   "role",                                                     :null => false
      t.boolean  "status",                                :default => false
      t.string   "token",                                                    :null => false
      t.string   "salt",                                                     :null => false
      t.string   "crypted_password",                                         :null => false
      t.string   "preferences"
    end

    add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  end
end
