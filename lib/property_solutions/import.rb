module PropertySolutions
  module Import

    def self.property_ids
      API.get_properties['PhysicalProperty']['Property'].map {|p| p['PropertyID']}
    end

    def self.properties_with_all_units
      API.get_property_units(property_ids.join(','))['PhysicalProperty']['Property']
    end

    def self.properties_with_available_units
      API.get_property_units(property_ids.join(','), true)['PhysicalProperty']['Property']
    end

    def self.import_properties_with_available_units
      properties_with_available_units.each do |raw|
        Import::Update.update Import::Property.new(raw)
      end
    end

    def self.import_properties_with_all_units
      properties_with_all_units.each do |raw|
        Import::Update.update Import::Property.new(raw)
      end
    end

    def self.disabled_property_ids
      API.get_properties['PhysicalProperty']['Property'].select{|p| p['IsDisabled'] == 1 }.map {|p| p['PropertyID']}
    end

    def self.enabled_property_ids
      API.get_properties['PhysicalProperty']['Property'].select{|p| p['IsDisabled'] == 0 }.map {|p| p['PropertyID']}
    end

    def self.disable_properties
      disabled_property_ids.each do |property_id|
        disable_property ::Property.find_by_gables_id(property_id)
      end
    end

    def self.enable_properties
      enabled_property_ids.each do |property_id|
        enable_property ::Property.find_by_gables_id(property_id)
      end
    end

    def self.disable_property property
      if property.present?
        if property.use_propertysolutions_data?
          property.update_attribute :published, false
        else
          data = JSON.parse(property.propertysolutions_data || '{}')
          data['published'] = false
          property.update_attribute :propertysolutions_data, data.to_json
        end
      end
    end

    def self.enable_property property
      if property.present?
        if property.use_propertysolutions_data?
          property.update_attribute :published, true
        else
          data = JSON.parse(property.propertysolutions_data || '{}')
          data['published'] = true
          property.update_attribute :propertysolutions_data, data.to_json
        end
      end
    end

    def self.import_amenities
      gables_ids = property_ids
      properties = ::Property.where(:gables_id => gables_ids)
      properties.each do |property|
        raw_amenities = API.get_amenities(property.gables_id)

        amenities = []

        if raw_amenities.present? && raw_amenities['Amenities'].present?
          general_amenities = raw_amenities['Amenities']['GeneralAmenities'].try(:[], 'Amenity') || []
          special_amenities = raw_amenities['Amenities']['SpecialAmenities'].try(:[], 'Amenity') || []
          amenities += (general_amenities + special_amenities).map do |raw|
            Import::Amenity.new raw
          end
        end
        
        Import::Update.update_association property, :amenities, amenities

      end
    end

  end
end
