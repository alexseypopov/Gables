module PropertySolutions

  def self.sync
    Rails.logger.warn "Started syncing at #{Time.now}(Property Solutions)"
    Import.import_properties_with_all_units
    Rails.logger.warn "Started enabling properties at #{Time.now}(Property Solutions)"
    Import.enable_properties
    Rails.logger.warn "Started disabling properties at #{Time.now}(Property Solutions)"
    Import.disable_properties

    Rails.logger.warn "Started importing amenities for properties at #{Time.now}(Property Solutions)"
    Import.import_amenities

    Rails.logger.warn "Started clearing orphans at #{Time.now}(Property Solutions)"
    clear_orphans
    Rails.logger.warn "Started clearing amenities at #{Time.now}(Property Solutions)"
    clear_amenities
    Rails.logger.warn "Started creating regions at #{Time.now}(Property Solutions)"
    create_new_regions
    Rails.logger.warn "Finished syncing at #{Time.now}(Property Solutions)"
  end
  

  def self.clear_orphans
    ::Floorplan.destroy_all(:from_propertysolutions => true, :property_id => nil)
  end

  def self.create_new_regions
    ::Property.select("DISTINCT(city),state").each do |p|
      region = Gca::Region.find_or_create_by_city_and_state(p.city, p.state)
    end
    Gca::Region.attach_properties
  end

  def self.clear_amenities
    with_properties = Amenity.where(:from_propertysolutions => true, :from_vaultware => false).joins(:properties).group('amenities_properties.amenity_id').pluck(:id)
    all = Amenity.where(:from_propertysolutions => true, :from_vaultware => false).pluck(:id)
    
    Amenity.destroy_all(:from_propertysolutions => true, :from_vaultware => false, :id => [all - with_properties])

  end


end
