module PropertySolutions
  module Import
    class Property < AbstractWraper

      def _hours value
        if value.blank? || value['OpenTime'].blank? || value['OpenTime'] == 'Closed'
          'Closed'
        elsif value['OpenTime'] == '0 AM' && value['CloseTime'] == '0 AM'
          'Available by Appointment'
        else
          "#{value['OpenTime']} - #{value['CloseTime']}"
        end
      end

      def _floorplans value
        (value || []).map do |source|
          Import::Floorplan.new source.merge('..' => @source)
        end
      end

      def _boolean value
        value.to_s == 'true'
      end

    end
  end
end

