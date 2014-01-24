# Contains methods for loading models from an XML document e.g.
#
#   doc = xml(file_path)
#   Load::property(doc, "//Property[110]")
#
# The first argument, parent, is the XML document or node, and the second, path, is the XPath
# path at which the data for the model is located
module Load
  class << self
    def property(parent, path)
      child = xpath(parent, path)
      p = Property.new
      p.pet_policy          = text        child, "Policy/General"
      p.allows_dogs         = bool        child, "Policy/Pet[@Type='Dog']"
      p.dog_policy          = text        child, "Policy/Pet[@Type='Dog']/Restrictions"
      p.allows_cats         = bool        child, "Policy/Pet[@Type='Cat']"
      p.cat_policy          = text        child, "Policy/Pet[@Type='Cat']/Restrictions"
      p.long_description    = text        child, "Information/LongDescription"
      p.short_description   = text        child, "Information/ShortDescription"
      p.name                = text        child, "PropertyID/ns:Identification/ns:MarketingName"
      p.gables_id           = text        child, "PropertyID/ns:Identification/ns:PrimaryID"
      p.insite_id           = integer     child, "PropertyID/ns:Identification/ns:SecondaryID"
      p.phone               = text        child, "PropertyID/ns:Phone[@Type='office']/ns:PhoneNumber"
      p.street              = text        child, "PropertyID/ns:Address/ns:Address1"
      p.address2            = text        child, "PropertyID/ns:Address/ns:Address2"
      p.city                = text        child, "PropertyID/ns:Address/ns:City"
      p.state               = text        child, "PropertyID/ns:Address/ns:State"
      p.zip                 = text        child, "PropertyID/ns:Address/ns:PostalCode"
      p.contact_form_email  = text        child, "PropertyID/ns:Address/ns:Email"
      p.vw_images           = images      child, "File"
      p.monday_hours        = hours       child, "Information/OfficeHour/Day[text()='Monday']/.."
      p.tuesday_hours       = hours       child, "Information/OfficeHour/Day[text()='Tuesday']/.."
      p.wednesday_hours     = hours       child, "Information/OfficeHour/Day[text()='Wednesday']/.."
      p.thursday_hours      = hours       child, "Information/OfficeHour/Day[text()='Thursday']/.."
      p.friday_hours        = hours       child, "Information/OfficeHour/Day[text()='Friday']/.."
      p.saturday_hours      = hours       child, "Information/OfficeHour/Day[text()='Saturday']/.."
      p.sunday_hours        = hours       child, "Information/OfficeHour/Day[text()='Sunday']/.."
      p.vw_specials            = specials    child, "Concession"
      p.vw_amenities           = amenities   child, "Amenity"
      p.vw_floorplans          = floorplans  child, "Floorplan"
      p.from_vaultware      = true
      p.backup_vaultware_data
      p.use_propertysolutions_data = false
      p
    end

    def floorplans(parent, path)
      xpath(parent, path).map do |child| 
        floorplan_id = child["Id"]
        f = Floorplan.new
        f.gables_id         = floorplan_id
        f.availability_url  = text      child, "FloorplanAvailabilityURL"
        f.bedrooms_count    = decimal   child, "Room[@Type='Bedroom']/Count"
        f.bathrooms_count   = decimal   child, "Room[@Type='Bathroom']/Count"
        f.name              = text      child, "Name"
        f.vw_images            = images    child, "File"
        f.vw_amenities         = amenities child, "Amenity"
        f.vw_specials          = specials  child, "Concession"
        f.vw_units             = units     child, "../ILS_Unit[@FloorplanID='#{floorplan_id}']"
        f.area_min          = xpath(child, "SquareFeet").first["Min"].to_i
        f.area_max          = xpath(child, "SquareFeet").first["Max"].to_i
        f.rent_min          = xpath(child, "EffectiveRent").first["Min"].to_f
        f.rent_max          = xpath(child, "EffectiveRent").first["Max"].to_f
        f.from_vaultware    = true
        f.backup_vaultware_data
        f.use_propertysolutions_data = false
        f
      end
    end

    def units(parent, path)
      xpath(parent, path).map do |child| 
        building_id = child["BuildingID"]
        u = Unit.new
        u.building_name     = text      child, "../Building[@Id='#{building_id}']/Name"
        u.name              = text      child, "Unit/ns:MarketingName"
        u.entry_floor       = integer   child, "EntryFloor"
        u.area_min          = integer   child, "Unit/ns:Information/ns:MinSquareFeet"
        u.area_max          = integer   child, "Unit/ns:Information/ns:MaxSquareFeet"
        u.gables_id         = text      child, "Unit/ns:Information/ns:UnitID"
        u.vw_amenities         = amenities child, "Amenity"
        u.vw_specials          = specials  child, "Concession"
        u.occupied          = bool      child, "Availability/VacancyClass[text()='Occupied']"
        u.available_on      = date      child, "Availability/VacateDate"
        u.rent_min          = xpath(child, "EffectiveRent").first["Min"].to_f
        u.rent_max          = xpath(child, "EffectiveRent").first["Max"].to_f
        u.from_vaultware  = true
        u.backup_vaultware_data
        u.use_propertysolutions_data = false
        u
      end
    end

    def amenities(parent, path)
      xpath(parent, path).map do |child| 
        a = Amenity.new
        a.description     = text     child, 'Description'
        a.rank            = integer  child, 'Rank'
        a.from_vaultware  = true
        a.backup_vaultware_data
        a.use_propertysolutions_data = false
        a
      end
    end

    def specials(parent, path)
      xpath(parent, path).map do |child| 
        s = Special.new
        s.header          = text child, 'DescriptionHeader'
        s.body            = text child, 'DescriptionBody'
        s.from_vaultware  = true
        s.backup_vaultware_data
        s.use_propertysolutions_data = false
        s
      end
    end

    def images(parent, path)
      xpath(parent, path).map do |child|
        i = Image.new
        i.vaultware_url   = text    child, 'Src'
        i.name            = text    child, 'Name'
        i.description     = text    child, 'Description'
        i.vaultware_url   = text    child, 'Src'
        i.position        = integer child, 'Rank'
        i.from_vaultware  = true
        i.backup_vaultware_data
        i.use_propertysolutions_data = false
        i
      end
    end

    def hours(parent, path)
      child = xpath(parent, path)
      return ""       if text(child, 'OpenTime').blank?
      return "Closed" if text(child, 'OpenTime') == 'Closed'
      return "#{text(child, 'OpenTime' )} - #{text(child, 'CloseTime')}"
    end

    def integer(node, path)
      xpath(node, path).text.to_i
    end

    def decimal(node, path)
      xpath(node, path).text.to_f
    end

    def date(node, path)
      child = xpath(node, path).first
      Date.new(child["Year"].to_i, child["Month"].to_i, child["Day"].to_i)
    end

    def bool(node, path)
      !xpath(node, path).empty?
    end

    def text(node, path)
      xpath(node, path).text.strip
    end

    def texts(node, path)
      xpath(node, path).map(&:text)
    end

    def xpath(node, path)
      node.xpath(path, "ns" => "http://my-company.com/namespace") 
    end
  end
end
