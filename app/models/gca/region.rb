class Gca::Region < ActiveRecord::Base
  has_many :property_regions
  has_many :properties, :through => :property_regions, :order => 'gca_property_regions.position ASC'
  attr_accessible :city, :state, :property_ids, :property_regions
  
  SeedList = YAML::load File.open(Rails.root.join('db/gca_region_seed_list.yml'), 'r') 

  # Loads the initial regions into the DB
  def self.seed
    SeedList.each do |region_state, fields|
      fields['cities'].each do |city|
        region = Gca::Region.find_or_initialize_by_city_and_state(city, region_state)
        region.save!
      end
    end
  end
  
  # Search on city, state of region and attach returned properties
  def self.attach_properties
    regions = self.all
    regions.each do |region|
      r = nil
      property_regions = nil
      query = "#{region.city}, #{Carmen::state_name(region.state)}"
      if region.properties.length == 0
        s = Search.new(:address => query)
        if s.properties.length > 0
          property_regions = []
          r = nil
          s.properties.each_with_index do |property, index|
            r = Gca::PropertyRegion.find_or_create_by_region_id_and_property_id(region.id, property.id)
            r.update_attributes!(:position => index)
            property_regions << r
          end
          region.update_attributes(:property_regions => property_regions)
        end
      end
    end
  end
  
  # Needed to allow ordering in admin
  def property_ids=(ids)
    property_regions = []

    ids.each_with_index do |id, index|
      r = nil
      if self.id && !id.blank?
        begin
          r = Gca::PropertyRegion.find_or_create_by_region_id_and_property_id(self.id, id)
        rescue ActiveRecord::RecordNotFound
          next
        end

        r.update_attributes!(:position => index)
        property_regions << r
      end
    end

    update_attributes(:property_regions => property_regions)
  end
end
