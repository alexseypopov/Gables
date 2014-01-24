require 'spec_helper'

describe FindController do
  context '#where' do
    it 'should not crash when query is specified' do
      get 'where', :group => 'community', :query => 'atlanta', :beds => '1', :baths => 'any',
                     :rent_max => '1100', :pet_friendly => 'dogs'
    end

    it 'should not crash when no query is specified' do
      get 'where', :query => ''
    end
  end

  context '#index' do
    it 'should not crash' do
      get 'index'
    end
  end

  context '#comparison' do
    it 'should not crash' do
      get 'comparison'
    end

    it 'should not crash when given invalid parameters' do
      @request.cookies['comparisons'] = {
        'units'       => {4 => 4, 20 => 20},
        'communities' => {2 => 2},
      }.to_json

      get 'comparison'
      response.status.should == 404
    end

    it 'should not crash when given valid parameters' do
      Factory.create(:property)
      Factory.create(:unit)

      @request.cookies['comparisons'] = {
        'units'       => {1 => 1},
        'communities' => {1 => 1},
      }.to_json

      get 'comparison'
    end

    it 'should not crash when given empty parameters' do
      @request.cookies['comparisons'] = {
        'units'       => {},
        'communities' => {},
      }.to_json

      get 'comparison'
    end
  end

  context '#community' do
    before(:all) do
      @property = Factory(:property)
    end

    it 'should not crash' do
      get 'community', :id => 5000
      response.status.should == 404
    end

    it 'should work with valid schedule' do
      get 'community', :id => @property.id, :schedule => {:first_name => 'a',
        :last_name => 'a', :phone => 'a', :email => 'a'}
    end

    it 'should work with invalid schedule' do
      get 'community', :id => @property.id, :schedule => {:first_name => ''}
    end

    it 'should work with no schedule' do
      get 'community', :id => @property.id
    end
  end

  #context '#unit' do
  #  before(:all) do
  #    @unit = Factory(:unit)
  #    @unit.create_floorplan
  #    @unit.save
  #  end

  #  it 'should work with valid schedule' do
  #    get 'unit', :id => @unit.id, :schedule => {:first_name => 'a', :last_name => 'a',
  #      :phone => 'a', :email => 'a'}
  #  end

  #  it 'should work with no schedule' do
  #    get 'unit', :id => @unit.id
  #  end
  #end  
end
