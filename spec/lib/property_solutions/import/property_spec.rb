require 'spec_helper'


module PropertySolutions
  module Import
    
    describe Property do
      let(:property) { Import::Property.new('') }
      it 'typecasts value to hours' do
        property._hours({'OpenTime' => ''}).should eq('')
        property._hours({'OpenTime' => 'Closed'}).should eq('Closed')
        property._hours({'OpenTime' => 'one', 'CloseTime' => 'two'}).should eq('one - two')
      end

      it 'typecasts value to array floorplans' do
        #Import::Floorplan.should_receive(:new).twice
        floorplans = property._floorplans([{},{}])
        floorplans[0].should be_instance_of(Import::Floorplan)
        floorplans[1].should be_instance_of(Import::Floorplan)
      end

      it 'typecasts value to array of amenities' do
        amenities = property._amenities([{},{}])
        amenities[0].should be_instance_of(Import::Amenity)
        amenities[1].should be_instance_of(Import::Amenity)
      end


    end

  end
end
