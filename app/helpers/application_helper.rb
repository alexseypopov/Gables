module ApplicationHelper
  def rent_range(floorplans)
    max_rent = floorplans.map(&:rent_max).max
    min_rent = floorplans.map(&:rent_min).min
    "#{number_to_currency(min_rent, :precision => 0)} - #{number_to_currency(max_rent, :precision => 0)}"
  end

  # state : String
  # => [String]
  def cities_for(state)
    @property_links.select{|p| p.state == state}.map(&:city).map(&:downcase).uniq.map(&:titleize).sort
  end
  
  def gca_cities_for(state)
    Gca::Region.where(:state => state).map(&:city).sort
  end

  def beds_options
    options_for_select([['any', ''], ['studio', '0'], ['1', '1'], ['2', '2'], ['3', '3'], ['4', '4'], ['5', '5']], params[:beds])
  end

  def baths_options
    options_for_select([['any', ''], ['1', '1'], ['1.5', '1.5'], ['2', '2'],  ['2.5', '2.5'], ['3', '3'],  ['3.5', '3.5'], ['4', '4'], ['5', '5']], params[:baths])
  end
end
