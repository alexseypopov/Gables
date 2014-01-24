require 'spec_helper'

describe Update do
  context '#floorplans' do
    it 'should mark units in floorplan but not in new floorplan as unavailable' do
      floorplan = Factory(:floorplan, :gables_id => '1')
      unit      = Factory(:unit, :occupied => false)
      floorplan.units << unit
      Update::floorplans([Factory.build(:floorplan, :gables_id => '1')]) 

      unit.reload.occupied.should be_true
    end
  end
end
