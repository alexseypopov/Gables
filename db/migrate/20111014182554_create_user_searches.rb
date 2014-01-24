class CreateUserSearches < ActiveRecord::Migration
  def self.up
    create_table :user_searches do |t|
      t.string :query
      t.integer :count

      t.timestamps
    end
  end

  def self.down
    drop_table :user_searches
  end
end
