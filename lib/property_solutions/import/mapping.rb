module PropertySolutions
  module Import

    MAPPING = {
      :property => {
        :pet_policy => ['Policy/General', :text],
        :allows_dogs => ['Policy/Pet[Pets\@attributes\PetType=Dog]/0/@attributes/Allowed', :boolean],
        :dog_policy => ['Policy/Pet[Pets\@attributes\PetType=Dog]/0/Pets/@attributes/Description', :text],
        :allows_cats => ['Policy/Pet[Pets\@attributes\PetType=Cat]/0/@attributes/Allowed', :boolean],
        :cat_policy => ['Policy/Pet[Pets\@attributes\PetType=Cat]/0/Pets/@attributes/Description', :text],
        :long_description => ['Information/LongDescription', :text],
        :short_description => ['Information/ShortDescription', :text],
        :name => ['PropertyID/MarketingName', :text],
        :gables_id => ['Identification/IDValue', :integer],
        :insite_id => ['PropertyID/Identification/OrganizationName', :integer],
        :phone => ['PropertyID/Phone[@attributes\PhoneType=office]/0/PhoneNumber', :text],
        :street => ['PropertyID/Address/Address', :text],
        :city => ['PropertyID/Address/City', :text],
        :state => ['PropertyID/Address/State', :text],
        :zip => ['PropertyID/Address/PostalCode', :text],
        :website => ['PropertyID/WebSite', :text],
        :contact_form_email => ['PropertyID/Address/Email', :text],
        :monday_hours => ['Information/OfficeHour[Day=Monday]/0', :hours],
        :tuesday_hours => ['Information/OfficeHour[Day=Tuesday]/0', :hours],
        :wednesday_hours => ['Information/OfficeHour[Day=Wednesday]/0', :hours],
        :thursday_hours => ['Information/OfficeHour[Day=Thursday]/0', :hours],
        :friday_hours => ['Information/OfficeHour[Day=Friday]/0', :hours],
        :saturday_hours => ['Information/OfficeHour[Day=Saturday]/0', :hours],
        :sunday_hours => ['Information/OfficeHour[Day=Sunday]/0', :hours],
        :floorplans => ['Floorplan', :floorplans, :association],
        :amenities => ['Amenity', :amenities, :association],
        :specials => ['Concession', :specials, :association],
        :images => ['File', :images, :association],
        :availability_url => ['Information/PropertyAvailabilityUrl', :text]
      },
      :floorplan => {
        :gables_id => ['Identification/IDValue', :integer],
        #:gables_id => ['Identification/OrganizationName', :integer],
        :availability_url => ['FloorplanAvailabilityURL', :text],
        :bedrooms_count => ['Room[@attributes\RoomType=Bedroom]/0/Count', :integer],
        :bathrooms_count => ['Room[@attributes\RoomType=Bathroom]/0/Count', :integer],
        :name => ['Name',:text],
        :area_min => ['SquareFeet/@attributes/Min', :integer],
        :area_max => ['SquareFeet/@attributes/Max', :integer],
        :rent_min => ['MarketRent/@attributes/Min', :decimal],
        :rent_max => ['MarketRent/@attributes/Max', :decimal],
        :images => ['File', :images, :association],
        :units => ['../ILS_Unit[Units\Unit\@attributes\FloorPlanId={#gables_id}]', :units, :association],
        :amenities => ['Amenity', :amenities, :association],
        :specials => ['Concession', :specials, :association],

      },
      :unit => {
        :building_id => ['Units/Unit/@attributes/BuildingId', :integer, :private],
        :building_name => ['../Building[Identification\IDValue={#building_id}]/0/Name', :text],
        :name => ['Units/Unit/MarketingName', :text],
        :entry_floor => ['EntryFloor', :integer],
        :area_min => ['Units/Unit/MinSquareFeet', :integer],
        :area_max => ['Units/Unit/MaxSquareFeet', :integer],
        :gables_id => ['Units/Unit/Identification/IDValue', :integer],
        #:gables_id => ['Units/Unit/Identification/OrganizationName', :integer],
        :occupied => ['Availability/VacancyClass', :boolean],
        :available_on => ['Availability/MadeReadyDate/@attributes', :date],
        :rent_min => ['EffectiveRent', :decimal],
        :rent_max => ['EffectiveRent', :decimal],
        :amenities => ['Amenity', :amenities, :association],
        :specials => ['Concession', :specials, :association],
      },
      :amenity => {
        :description => ['Description', :text],
        :rank => ['Rank', :integer]
      },
      :special => {
        :header => ['DescriptionHeader', :text],
        :body => ['DescriptionBody', :text]
      },
      :image => {
        :name => ['Name', :text],
        :description => ['Description', :text],
        :position => ['Rank', :integer],
        :propertysolutions_url => ['Src', :text]
      }
    }
  end
end
