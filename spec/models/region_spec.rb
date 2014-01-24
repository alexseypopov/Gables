require 'spec_helper'

describe Region do
  context '.seed' do
    it 'should import everything in SeedList' do
      Region.seed
      Region.count.should == Region::SeedList.length
    end

    it 'should overwrite similarly-named regions if they exist' do
      region_name = 'Jacksonville'
      r = Factory(:region, :name => region_name, :latitude => 0.0)
      Region.seed
      Region.find_by_name(region_name).latitude.should_not == 0.0
    end
  end
end
