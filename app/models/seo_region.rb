class SeoRegion < ActiveRecord::Base
  belongs_to :region
  has_and_belongs_to_many :properties
  attr_accessible :property_ids, :region_id
  
  def region_id_enum
    Region.where(:for_seo => true).map {|region| [region.name, region.id]}
  end
end
