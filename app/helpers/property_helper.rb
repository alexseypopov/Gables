module PropertyHelper
  def pet_friendly(property)
    if property.allows_dogs == true && property.allows_cats == true
      'Cats and Dogs'
    elsif property.allows_dogs == true && property.allows_cats == false
      'Dogs Allowed'
    elsif property.allows_dogs == false && property.allows_cats == true
      'Cats Allowed'
    else
      'No'
    end
  end
end
