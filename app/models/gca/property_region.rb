class Gca::PropertyRegion < ActiveRecord::Base
  validates_non_nilness_of :position
  belongs_to :property
  belongs_to :region
  attr_accessible :property_id, :region_id, :position
end
