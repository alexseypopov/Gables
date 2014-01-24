class Floorplan < ActiveRecord::Base
  has_and_belongs_to_many :amenities
  belongs_to  :property
  has_many  :units
  has_many  :specials,  :dependent => :destroy, :as => :specialable
  has_many  :images,    :dependent => :destroy, :as => :imageable

  include SetGablesId
  include DataSourceSwitch
  before_create :set_gables_id

  validates_non_nilness_of  :name, :gables_id, :bedrooms_count, :bathrooms_count, :area_min,
                            :from_vaultware
  attr_accessible :bedrooms_count, :bathrooms_count, :name, :area_min, :area_max, :gables_id, :availability_url, :rent_min, :rent_max, :from_vaultware, :use_propertysolutions_data, :from_propertysolutions, :propertysolutions_data, :vaultware_data

  validates :units,     :vaultware_exclusivity => true, :propertysolutions_exclusivity => true
  validates :specials,  :vaultware_exclusivity => true, :propertysolutions_exclusivity => true
  validates :amenities, :vaultware_exclusivity => true, :propertysolutions_exclusivity => true

  VaultwareColumns = [
    "from_vaultware",
    "name",
    "gables_id",
    "bedrooms_count",
    "bathrooms_count",
    "area_min",
    "area_max",
    "availability_url",
    "rent_min",
    "rent_max"
  ]

  PropertysolutionsColumns = [
    'gables_id',
    'availability_url',
    'bedrooms_count',
    'bathrooms_count',
    'name',
    'area_min',
    'area_max',
    'rent_min',
    'rent_min'
  ]

  def self.with_property_amenities_in(descriptions)
    where_str = descriptions.map {
      "amenities.description REGEXP concat('.*', ?, '.*')"
    }

    properties = Property.select(:'properties.id').joins(:amenities)
      .where(where_str.join(" OR "), *descriptions)

    self.joins(:property).where(:"properties.id" => properties)
  end

  def self.with_amenities_in(descriptions)
    where_str = descriptions.map {
      "amenities.description REGEXP concat('.*', ?, '.*')"
    }
  
    units = Unit.select(:'units.id').joins(:amenities)
      .where(where_str.join(" OR "), *descriptions)

    self.joins(:amenities, :units)
        .where(:"units.id" => units)
        .or.where(where_str.join(" OR "), *descriptions)
  end

  def to_param
    "#{id}-#{name.to_url}"
  end

  def rails_admin_label
    "#{id} #{name}"
  end
end

