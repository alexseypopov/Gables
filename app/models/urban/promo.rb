class Urban::Promo < ActiveRecord::Base
  validates_non_nilness_of :heading, :position
  mount_uploader :image, Urban::PromoUploader
  attr_accessible :heading, :text, :link, :image, :position, :video_id
  def self.by_position_asc
    order(:position)
  end
end
