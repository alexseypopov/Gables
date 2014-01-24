class CreateExecutives < ActiveRecord::Migration
  def self.up
    create_table :executives do |t|
      t.string  :name,            :null => false, :default => ''
      t.string  :title,           :null => false, :default => ''
      t.text    :office_address,  :default => ''
      t.string  :phone,           :default => ''
      t.string  :email,           :default => ''
      t.text    :bio,             :default => ''
      t.string  :image

      t.timestamps
    end
  end

  def self.down
    drop_table :executives
  end
end
