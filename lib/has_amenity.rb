module HasAmenity
  def has_amenity?(description)
    amenities.where("description REGEXP concat('.*', ?, '.*')", description).exists?
  end
end
