class Urban::Image < ActiveRecord::Base
  belongs_to :property
  mount_uploader :image, Urban::ImageUploader
  delegate :url, :path, :thumb, :to => :image
  alias :to_s :url
  attr_accessible :image, :property_id, :position
  def rails_admin_label
    "#{id} #{self["image"]}"
  end
end
