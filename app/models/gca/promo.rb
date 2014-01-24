class Gca::Promo < ActiveRecord::Base
  validates_non_nilness_of :heading, :position
  mount_uploader :image, Gca::PromoUploader

  attr_accessible :image, :heading, :text, :link, :position, :video_id

  def self.by_position_asc
    order(:position)
  end
end
