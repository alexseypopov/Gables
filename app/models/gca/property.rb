class Gca::Property < Property
  has_many :property_regions
  has_many :regions, :through => :property_regions

  attr_accessible :property_regions

end
