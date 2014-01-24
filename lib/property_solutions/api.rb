module PropertySolutions
  module API

    CONFIG = {
      :password => Rails.configuration.x.property_solutions.password,
      :username => Rails.configuration.x.property_solutions.username,
      :domain => Rails.configuration.x.property_solutions.domain,
      :methods_urls => {
        'getProperties' => '/api/properties',
        'getMitsPropertyUnits' => '/api/propertyunits',
        'getAmenities' => '/api/propertyunits'
      }
    }

    class << self

      def get_properties
        get_data API::Request.new('getProperties', :showAllStatus => '1')
      end

      def get_property_units ids, only_avalible=false
        get_data API::Request.new('getMitsPropertyUnits', :propertyIds => ids, :avalibleUnitsOnly => (only_avalible ? '1' : '0'))
      end

      def get_amenities property_id
        get_data API::Request.new('getAmenities', :propertyId => property_id)
      end

      def get_data api_request
        execute(api_request).result
      end
      
      def execute api_request
        API::Response.new(api_request.execute)
      end

    end

  end
end
