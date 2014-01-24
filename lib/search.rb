# To use the search interface, instantiate the Search class then call _properties_,
# _floorplans_for_, or _units_for_. To list all the units found for the search criteria, use
# the following
#
#   s = Search.new(:address => 'atlanta')
#
#   s.properties.each do |property|
#     s.floorplans_for(property).each do |floorplan|
#       s.units_for(floorplan).each do |unit|
#         puts unit
#       end
#     end
#   end
#
# Simply calling <tt>s.properties.map(&:floorplans)</tt> will list all the floorplans for the
# given properties rather than the floorplans that matched the search criteria.
class Search
  attr_accessor :properties
  SearchRadius = 17

  # Takes the following options
  # 
  # :address              String    properties within the search radius of this address will be found.
  # :beds                 Float     Number of beds
  # :baths                Float     Number of baths (we can have 1.5 baths)
  # :rent_min             Float
  # :rent_max             Float
  # :allows_pets          Symbol    returns all units if not one of :cats, :dogs, or :both.
  # :availability         Symbol    :now or :any. Default is :any. :now selects only units that
  #                                 are currently unoccupied
  # :property_amenities   [String]  properties which have amenities whose descriptions  that match all the
  #                                 items in the list
  # :unit_amenities       [String]
  # :order_by             Symbol    :rent. orders properties by rent of cheapest floorplan.
  #                                 sorts by geocoded distance by default.
  def initialize(options={})
    address             = !options[:address].blank? ? options[:address].squeeze(" ").strip.delete("\\") : ""
    beds                = !options[:beds].blank? ? options[:beds].to_f : nil
    baths               = !options[:baths].blank? ? options[:baths].to_f : nil
    rent_min            = options[:rent_min].blank? ? 0 : options[:rent_min].to_f
    rent_max            = options[:rent_max].blank? ? Floorplan.maximum(:rent_max) : options[:rent_max].to_f
    allows_dogs         = options[:allows_pets].blank? ? false : [:dogs, :both].include?(options[:allows_pets].to_sym)
    allows_cats         = options[:allows_pets].blank? ? false : [:cats, :both].include?(options[:allows_pets].to_sym)
    availability        = options[:availability].blank? ? :any : options[:availability].to_sym
    property_amenities  = options[:property_amenities].blank? ? [] : options[:property_amenities]
    unit_amenities      = options[:unit_amenities].blank? ? [] : options[:unit_amenities]
    order_by            = options[:order_by].blank? ? :distance : options[:order_by].to_sym

    floorplans = Floorplan.joins(:property, :units).
      where("properties.published = true").
      where("properties.allows_dogs = true OR properties.allows_dogs = ?", allows_dogs).
      where("properties.allows_cats = true OR properties.allows_cats = ?", allows_cats).
      where("floorplans.rent_min >= ?", rent_min).
      where("floorplans.rent_min <= ?", rent_max)

    floorplans  = floorplans.joins(:units) if availability == :now
    floorplans  = floorplans.where("bedrooms_count = ?", beds) if beds
    floorplans  = floorplans.where("bathrooms_count = ?", baths) if baths
    floorplans  = floorplans.with_amenities_in(unit_amenities) if unit_amenities.present?
    floorplans  = floorplans.with_property_amenities_in(property_amenities) if property_amenities.present?
    @floorplans = floorplans

    floorplanless_properties  = availability == :now ?
                                  [] : Property.select(:id).map(&:id) - Floorplan.select(:property_id).map(&:property_id)
    property_ids              = (floorplans.map(&:property_id) + floorplanless_properties).uniq
    region                    = Region.where("name LIKE ?", address).first
    if(region)
      seo_region = SeoRegion.where("region_id = ?", region.id).first
    end

    if region && region.properties.count > 0
      @properties = region.properties.near([region.latitude, region.longitude], 3000)
    elsif seo_region && seo_region.properties.count > 0
      @properties = seo_region.properties.near([region.latitude, region.longitude], 3000)
    elsif Property.where("name LIKE ?", address).exists?
      @properties = Property.where("properties.name LIKE ?", address)
    elsif Property.where("city LIKE ?", address).exists?
      property = Property.where("city LIKE ?", address).first
      @properties = Property.near("#{property.city}, #{property.state}", SearchRadius)
    elsif Property.where("state LIKE ?", Carmen::state_code(address)).exists?
      @properties = Property.where("state LIKE ?", Carmen::state_code(address))
    else
      # N.B. Model.near isn't chainable
      @properties = Property.near(address, SearchRadius)
    end

    @properties = @properties.where(:id => property_ids)

    if order_by == :rent
      @properies = @properties.order('floorplans.rent_min ASC')
    end

    @properties
  end

  def floorplans_for(property)
    property.floorplans.where(:id => @floorplans)
  end

  def units_for(floorplan)
    floorplan.units
  end

  def inspect
    "#<Search:#{object_id} #{@properties.length} properties>"
  end
end
