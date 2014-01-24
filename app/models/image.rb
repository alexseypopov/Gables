class Image < ActiveRecord::Base
  belongs_to :imageable, :polymorphic => true
  mount_uploader :image, ImageUploader
  delegate :url, :path, :thumb, :to => :image
  attr_accessible :from_vaultware, :vaultware_url, :image, :imageable_id, :imageable_type, :position, :name, :description, :use_propertysolutions_data, :from_propertysolutions, :propertysolutions_data, :vaultware_data, :propertysolutions_url
  alias :to_s :url
  include DataSourceSwitch

  def self.from_vaultware
    where(:from_vaultware => true)
  end

  def self.fetch_vaultware_images
    total = Image.from_vaultware.count

    Image.from_vaultware.each do |image|
      puts "#{image.id}/#{total}"
      image.remote_image_url = image.vaultware_url
      image.save!
    end
  end

  def rails_admin_label
    "#{id} #{self["image"]}"
  end
end
