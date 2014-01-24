class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string  :kind,          :null => false, :default => 'NewsItem'
      t.text    :summary,       :null => false, :default => ''
      t.text    :text,          :null => false, :default => ''
      t.string  :title,         :null => false, :default => ''
      t.boolean :featured,      :null => false, :default => false
      t.date    :published_at,  :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
