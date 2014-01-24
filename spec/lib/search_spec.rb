require 'spec_helper'

describe Search do
  before(:all) do
    Region.seed
    Vaultware.import(Rails.root.join('spec/lib/test.xml'))
  end

  def properties(s)
    properties  = s.properties
  end

  def floorplans(s)
    floorplans  = properties(s).map { |property| s.floorplans_for(property) }.flatten
  end
  
  def units(s)
    floorplans(s).map { |floorplan| s.units_for(floorplan) }.flatten
  end

  it 'should return a region\'s properties when search query is a region name' do
    region        = Region.find_by_name('Washington DC')
    property_name = 'Propety'
    property      = Property.find_by_name(property_name)
    property.floorplans.create
    property.floorplans.first.units.create(:occupied => false, :available_on => Date.today)
    region.properties << property
    region.save
    property.save

    s = Search.new(:address => region.name)
    s.properties.length.should == 1
    s.properties.first.name.should == property_name
  end

  it 'should not crash' do
    lambda {
      s = Search.new(:beds => 2)
      s.properties.length
      s.inspect
    }.should_not raise_error
  end

  it 'should not crash when ordering by rent' do
    s = Search.new(:order_by => :rent)
  end

  it 'should not crash when ordering by rent and querying on an exact property name' do
    s = Search.new(:address => Property.first.name, :order_by => :rent)
  end

  it 'should return all the floorplans of a property searched by exact property name' do
    s = Search.new(:address => Property.first.name)
    s.floorplans_for(s.properties.first).length.should == s.properties.first.floorplans.count
  end

  it 'should find all units by default' do
    s = Search.new(:address => Property.first.name)
    units(s).length.should == Property.first.units.count
  end

  it 'should find units that could be had for 1000 < x < 2000' do
    s = Search.new(:address => 'Memphis', :rent_min => 1000, :rent_max => 2000)

    units(s).each do |unit|
      unit.rent_min.should >= 1000
      unit.rent_min.should <= 2000
    end
  end

  it 'should find no units from unpublished properties' do
    property  = Factory(:property, :published => false)
    floorplan = Factory(:floorplan, :bedrooms_count => 1000)
    floorplan.units     << Factory(:unit, :occupied => false)
    property.floorplans << floorplan
    
    s = Search.new(:address => 'Memphis', :beds => 1000)
    s.properties.length.should == 0
  end

  it 'should return 1 property if a property name is the query param and it matches other params' do
    s = Search.new(:address => 'Arbors Of Harbor Town')
    s.properties.length.should ==  1
  end

  it 'should not find properties whose amenities don\'t match' do
    s = Search.new(:property_amenities => ['Excommunication'])
    s.properties.length.should == 0
  end

  it 'should not crash when serching by unit and property amenities' do
    s = Search.new(:property_amenities => ['Excommunication'], :unit_amenities => ['lake'])
  end

  it 'should return floorplans with exactly specified number of bathrooms' do
    s = Search.new(:address => 'Memphis', :baths => 1)

    s.properties.all.each do |property|
      s.floorplans_for(property).each do |floorplan|
        floorplan.bathrooms_count.should == 1
      end
    end
  end

  it 'should return all properties with address in a state when state name is used as query' do
    s = Search.new(:address => 'Tennessee')
    s.properties.length.should == 1
  end

  it 'should apply other filters even if searchnig by state name' do
    s = Search.new(:address => 'Tennessee', :beds => 1000)
    s.properties.length.should == 0
  end

  it 'should return only floorplans with units when availability is :now' do
    s = Search.new(:availability => :now, :address => 'Arbors of Harbor Town')

    s.floorplans_for(s.properties.first).each do |floorplan|
      floorplan.units.count.should > 0
    end
  end

  it 'should import fractional bathrooms correctly' do
    s = Search.new(:address => 'Arbors Of Harbor Town')
    s.properties.first.floorplans.find_by_name('Beech').bathrooms_count.should == 2.5
  end
end
