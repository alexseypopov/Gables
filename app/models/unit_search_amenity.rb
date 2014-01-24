class UnitSearchAmenity < SearchAmenity
  attr_accessible :description
  def self.select_list
    all.map(&:description)
  end
end
