module PropertySolutions
  module Import
    class Floorplan < AbstractWraper
      def _units values
        values.map do |source|
          Import::Unit.new source.merge('..' => @source['..'])
        end
      end
    end
  end
end

