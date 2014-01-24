module FindHelper
  def h1
    @h1 = if @s.properties.length > 0
      "<strong>&ldquo;#{@query}&rdquo;</strong> Apartments; we found #{pluralize(@s.properties.length, 'community')}"
    else
      if params[:beds].blank? && params[:baths].blank? && params[:rent_min].blank? && params[:rent_max].blank? && params[:pet_friendly].blank? && params[:amenities].blank? && params[:features].blank? && params[:order].blank? && params[:floorplans].blank?
      "Your search for <strong>&ldquo;#{@query}&rdquo;</strong>returned no results. Select from one of our locations below or try a new search."
      else
        "Your filtered search for <strong>&ldquo;#{@query}&rdquo;</strong>returned no results. Select from one of our locations below or try a new search."
      end
    end
  end

  def rooms(floorplan)
    if floorplan.bedrooms_count == 0
      "Studio"
    else
      "#{floorplan.bedrooms_count} Bedroom / #{floorplan.bathrooms_count} Bath"
    end
  end

  def area(unit)
    if unit.area_min == unit.area_max
      unit.area_min
    elsif unit.area_max
      "#{unit.area_min} - #{unit.area_max}"
    else
      unit.area_min
    end
  end

  def reserve_prequalify_url unit, floorplan, property
    "#{property.website}/?module=check_availability&property_floorplan[id]=#{floorplan.gables_id}&unit_space[id]=#{unit.gables_id}&from_property_info=1&floorplan_availability_filter[number_of_bedrooms]=&floorplan_availability_filter[number_of_occupants]=1"
  end

  def apply_online_url unit
    "http://extra.gables.com/Onlineleasing/007_DS_Inbound.aspx?PUNIT_PSI_ID=#{unit.gables_id}" 
  end

  def notify_me_when_available_url floorplan, property
    "#{property.website}/Apartments/module/guest_card/property[id]/#{property.gables_id}/pf[id]/#{floorplan.gables_id}/from_check_availability/1/is_availability_alert/1/lightwindow/1/"
  end

end
