class Unit < ActiveRecord::Base
  has_and_belongs_to_many :amenities, :order => "rank ASC"
  has_many  :specials, :dependent => :destroy, :as => :specialable
  belongs_to  :floorplan

  include HasAmenity
  include SetGablesId
  include DataSourceSwitch
  before_create :set_gables_id

  VaultwareColumns = [
    "from_vaultware",
    "name",
    "gables_id",
    "occupied",
    "rent_min",
    "rent_max",
    "entry_floor",
    "area_min",
    "area_max",
    "building_name",
    "available_on"
  ]

  PropertysolutionsColumns = [
    'building_id',
    'building_name',
    'name',
    'area_min',
    'area_max',
    'gables_id',
    'occupied',
    'available_on',
    'rent_min',
    'rent_max'
  ]

  validates_non_nilness_of  :name, :gables_id, :building_name, :availability_url,
                          :rent_min, :rent_max, :entry_floor, :area_min,
                          :from_vaultware
  validates :specials,  :vaultware_exclusivity => true, :propertysolutions_exclusivity => true
  validates :amenities, :vaultware_exclusivity => true, :propertysolutions_exclusivity => true

  attr_accessible :from_vaultware, :occupied, :name, :rent_min, :rent_max, :entry_floor, :area_min, :area_max, :gables_id, :building_name, :available_on, :use_propertysolutions_data, :from_propertysolutions, :propertysolutions_data, :vaultware_data

  def self.inheritance_column
  "_no_inheritance_"
  end

  def availability_url
    if from_vaultware && floorplan && floorplan.property
      "http://units.realtydatatrust.com/RequestToHold.aspx?propid=#{floorplan.property.gables_id}&uid=#{self.gables_id}&ILS=28&fid=#{floorplan.gables_id}"
    else
      read_attribute(:availability_url)
    end
  end

  def rails_admin_label
    "#{id} #{name}"
  end
end
