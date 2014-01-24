class CreatePromos < ActiveRecord::Migration
  def self.up
    create_table "promos", :force => true do |t|
      t.string   "heading",    :default => "", :null => false
      t.text     "text"
      t.string   "link"
      t.string   "image"
      t.integer  "position",   :default => 0,  :null => false
      t.string   "video_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end

  def self.down
    drop_table "promos"
  end
end
