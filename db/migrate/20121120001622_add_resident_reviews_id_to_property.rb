class AddResidentReviewsIdToProperty < ActiveRecord::Migration
  def self.up
    add_column :properties, :resident_reviews_id, :string
  end

  def self.down
    remove_column :properties, :resident_reviews_id
  end
end
