require 'spec_helper'

describe VaultwareExclusivityValidator do
  it 'should not allow vaultware models to have any non-vaultware models' do
    a = Factory(:amenity,   :from_vaultware => false)
    p = Factory(:property,  :from_vaultware => true)
    p.amenities << a
    p.save.should be_false
  end

  it 'should allow non-vaultware models to have vaultware models' do
    p = Factory(:property,  :from_vaultware => false)
    f = Factory(:floorplan, :from_vaultware => true)
    p.floorplans << f
    p.save.should be_true
  end
end
