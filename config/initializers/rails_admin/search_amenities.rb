if defined?(SearchAmenity)
  [PropertySearchAmenity, UnitSearchAmenity].each do |search_amenity_class|
    RailsAdmin.config do |config|
      config.model search_amenity_class do

        list do
          field :id
          field :description
        end

        edit do
          field :description
        end
      end
    end
  end
end
