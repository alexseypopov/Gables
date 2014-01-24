class CreateUrbanProperties < ActiveRecord::Migration
  def self.up
    create_table :urban_properties do |t|
      t.text     "short_description",  :default => ""
      t.text     "long_description",   :default => ""
      t.text     "shopping_etc",       :default => ""
      t.integer  "opening_year",       :default => 0
      t.integer  "apartments_count",   :default => 0
      t.integer  "square_footage",     :default => 0
      t.text     "site_url",           :default => ""
      t.text     "map_url",            :default => ""
      t.string   "name",               :default => "",    :null => false
      t.string   "phone",              :default => "",    :null => false
      t.string   "street",             :default => "",    :null => false
      t.string   "city",               :default => "",    :null => false
      t.string   "state",              :default => "",    :null => false
      t.string   "zip",                :default => "",    :null => false
      t.string   "email",              :default => "",    :null => false
      t.string   "full_brochure"

      t.timestamps
    end
  end

  def self.down
    drop_table :urban_properties
  end
end
