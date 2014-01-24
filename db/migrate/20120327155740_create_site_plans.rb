class CreateSitePlans < ActiveRecord::Migration
  def self.up
    create_table :site_plans do |t|
      t.string     :image
      t.references :property
    end
  end

  def self.down
    drop_table :site_plans
  end
end
