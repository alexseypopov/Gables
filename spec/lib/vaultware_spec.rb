require 'spec_helper'

describe Vaultware do
  before(:all) do
    Factory(:property, :gables_id => '13504', :from_vaultware => true,
              :yelp_id => "YELP", :region_id => 1)
    Region.seed
    Vaultware.import(Rails.root.join("spec/lib/test.xml"))
  end

  it 'should keep all non-vaultware fields after a sync' do
    Property.find_by_gables_id('13504').yelp_id.should    == "YELP"
    Property.find_by_gables_id('13504').region_id.should  == 1
  end

  context 'after multiple syncs' do
    before(:all) do
      Vaultware.import(Rails.root.join("spec/lib/test-for-property-deletion.xml"))
    end

    it 'should correctly set timestamps for properties' do
      Property.where(:updated_at => nil).count.should == 0
      Property.where(:created_at => nil).count.should == 0
    end

    it 'should correctly set timestamps for floorplans' do
      Floorplan.where(:updated_at => nil).count.should == 0
      Floorplan.where(:created_at => nil).count.should == 0
    end

    it 'should not delete any properties' do
      Property.count.should == 2
    end
  end

  it 'should import properties properly' do
    Property.first.gables_id.should == "13504"
  end

  it 'should import floorplans properly' do
    Property.first.floorplans.count.should == 7
  end

  it 'should import floorplan urls' do
    f = Floorplan.find_by_gables_id("12042")
    f.availability_url.should == "http://units.realtydatatrust.com/unitavailability.aspx?ils=524&fid=12042"
  end

  it 'should import units properly' do
    f = Floorplan.find_by_gables_id("12042")
    f.units.count.should == 4
  end

  it 'should import unit building numbers' do
    u = Unit.find_by_gables_id("954606")
    u.building_name.should == "15"
  end

  it 'should import images properly' do
    Image.all.each {|i| i.image.path.should_not be_nil}
  end

  it 'should import all images' do
    Property.first.images.count.should == 1
  end

  it 'should be idempotent' do
    property_count  = Property.count
    floorplan_count = Floorplan.count
    unit_count      = Unit.count
    amenity_count   = Amenity.count
    special_count   = Special.count

    Vaultware.import(Rails.root.join("spec/lib/test.xml"))
    Property.count.should   == property_count
    Floorplan.count.should  == floorplan_count
    Unit.count.should       == unit_count     
    Amenity.count.should    == amenity_count  
    Special.count.should    == special_count  
  end
end
