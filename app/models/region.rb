class Region < ActiveRecord::Base
  has_many :properties
  has_many :seo_regions, :dependent => :destroy
  validates_uniqueness_of :name
  validates_non_nilness_of   :name, :latitude, :longitude, :description
  attr_accessible :name, :for_seo, :description, :latitude, :longitude, :created_at, :updated_at, :property_ids

  SeedList = YAML::load File.open(Rails.root.join('db/region_seed_list.yml'), 'r') 

  # Loads the initial regions into the DB
  def self.seed
    SeedList.each do |region_name, fields|
      region = Region.find_or_initialize_by_name(region_name)
      region.latitude  = fields['latitude']
      region.longitude = fields['longitude']
      region.save!
    end
  end
end
