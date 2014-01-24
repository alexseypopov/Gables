require 'spec_helper'

describe PropertyHelper do
  context 'pet_friendly' do
    it 'should return a string' do
      [pet_friendly(Property.new(:allows_cats => true)),
       pet_friendly(Property.new(:allows_dogs => true)),
       pet_friendly(Property.new(:allows_cats => true, :allows_dogs => true)),
       pet_friendly(Property.new)
      ].each {|result| result.class.should == String}
    end
  end
end
