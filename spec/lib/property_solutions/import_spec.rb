require 'spec_helper'

GET_PROPERTIES = JSON.parse('{"PhysicalProperty":{"Property":[{"PropertyID":63780,"MarketingName":"Gables Villa Rosa","Type":"Apartment","YearBuilt":"1981","ShortDescription":"A short desc for villa rosa.","LongDescription":"A long description for villa rosa.","IsDisabled":0},{"PropertyID":67741,"MarketingName":"Test 2","Type":"Apartment","IsDisabled":0},{"PropertyID":63705,"MarketingName":"Test Gables","Type":"Management Company","IsDisabled":1},{"PropertyID":67530,"MarketingName":"Test Send Mits","Type":"Apartment","IsDisabled":0},{"PropertyID":67934,"MarketingName":"Wilton Park","Type":"Apartment","IsDisabled":0}]}}')

module PropertySolutions
  describe Import do
    it 'gets property ids from api' do
      API.stub(:get_properties).and_return(GET_PROPERTIES)
      Import.property_ids.should eq([63780, 67741, 63705, 67530, 67934])
    end
    it 'gets available properties from api by ids' do
      Import.stub(:property_ids).and_return([1,2,3])
      API.should_receive(:get_property_units).with('1,2,3',true)
      Import.properties_with_available_units
    end

  end
  
end
