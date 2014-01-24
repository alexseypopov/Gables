class LifeSlide < ActiveRecord::Base
  mount_uploader :image, LifeSlideImageUploader
  validates_non_nilness_of :position
  attr_accessible :image, :position
  def self.by_position_asc
    order(:position)
  end
end
