module PropertySolutions
  module Import
    class Unit < AbstractWraper
    
      def _boolean value
        value.present? && value == 'Occupied'
      end
    
    end
  end
end

