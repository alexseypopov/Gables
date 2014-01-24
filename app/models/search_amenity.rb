# Search Amenities represent the list of unit amenities one can search by
class SearchAmenity < ActiveRecord::Base
  validates_non_nilness_of :description
  
  def self.select_list
    all.map(&:description)
  end
end
