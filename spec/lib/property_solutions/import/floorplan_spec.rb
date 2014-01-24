require 'spec_helper'

module PropertySolutions
  module Import

    describe Floorplan do
    
      it 'typecasts units' do
        plan = Import::Floorplan.new('') 
        Import::Unit.should_receive(:new).twice
        plan._units(%w{a b})
      end

      xit 'gets units by id'


    end

  end
end
