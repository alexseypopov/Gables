class PropertySeoRegion < ActiveRecord::Base
  belongs_to :seo_region
  belongs_to :property
end
