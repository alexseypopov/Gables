class Amenity < ActiveRecord::Base
  has_and_belongs_to_many :units
  has_and_belongs_to_many :properties
  has_and_belongs_to_many :floorplans

  validates_non_nilness_of :description, :rank

  attr_accessible :rank, :description, :from_vaultware, :use_propertysolutions_data, :from_propertysolutions, :propertysolutions_data, :vaultware_data

  include DataSourceSwitch

  # for rails_admin
  def custom_label_method
    "#{id} #{description}"
  end
end
