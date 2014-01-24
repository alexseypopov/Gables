class LabelledSlide < ActiveRecord::Base
  set_table_name "home_slides"
  mount_uploader :image, HomeSlideImageUploader
  validates_non_nilness_of :title, :position

  def self.by_position_asc
    order(:position)
  end
end
