require 'spec_helper'

describe 'Property' do
  context '#available_floorplans' do
    it 'should start off empty' do
      property = Factory(:property)
      property.available_floorplans.should == []
    end
  end

  context '#unavailable_floorplans' do
    it 'should start off empty' do
      property = Factory(:property)
      property.unavailable_floorplans.should == []
    end
  end

  context '#destroy' do
    it 'should also destroy dependent images and specials' do
      f = Factory(:floorplan)
      p = Factory(:property)
      s = Factory(:special)
      i = Factory(:image)

      f.specials  << s
      p.images    << i

      p.destroy
      f.destroy
      Special.count.should  == 0
      Image.count.should    == 0
    end
  end

  context '#has_amenity?' do
    before(:all) do
      @p = Factory(:property)
      @p.amenities.create(:description => 'lake view')
    end

    it 'should return true if it has a matching amenity' do
      @p.has_amenity?('view').should be_true
    end

    it 'should return false if it does not have a matching amenity' do
      @p.has_amenity?('granite').should be_false
    end
  end
end
