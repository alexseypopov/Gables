class AddEditableFieldsToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :yelp_id,           :string
    add_column :properties, :video_id,          :string
    add_column :properties, :contact_form_email,:string
    add_column :properties, :blog_url,          :text
    add_column :properties, :facebook_url,      :text
    add_column :properties, :twitter_url,       :text
    add_column :properties, :green_initiatives, :text
    add_column :properties, :show_walkscore,    :boolean, :null => false, :default => true
    add_column :properties, :show_ratings,      :boolean, :null => false, :default => true
  end

  def self.down
    remove_column :properties, :yelp_id
    remove_column :properties, :blog_url
    remove_column :properties, :facebook_url
    remove_column :properties, :twitter_url
    remove_column :properties, :show_walkscore
    remove_column :properties, :video_id
    remove_column :properties, :show_ratings
    remove_column :properties, :green_initiatives
    remove_column :properties, :contact_form_email
  end
end
