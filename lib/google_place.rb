class GooglePlace
  
  @@key = {key:"AIzaSyC85R5Wq8IzS3LjsMiZd-68gLc-DYqGWTU"}
  @@url = "https://maps.googleapis.com/maps/api/place"

  def self.search(options={})
    JSON.parse CurbFu.get("#{@@url}/search/json",options.merge(@@key)).body
  end

  def self.details(options={})
    JSON.parse CurbFu.get("#{@@url}/details/json",options.merge(@@key)).body
  end

  def address
    self.attributes['google_address']
  end

  def fetch_details
    response = GooglePlace.details({
      reference: self.reference,
      sensor: "false"
    })
    details = response['result']
    details.delete "reviews"
  end

end
