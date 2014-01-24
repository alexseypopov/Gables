class SitePlan < ActiveRecord::Base
  belongs_to :property
  mount_uploader :image, SitePlanUploader

  attr_accessible :image_map, :property_id, :image
end
