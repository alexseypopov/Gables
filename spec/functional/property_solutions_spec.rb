require 'spec_helper'

def test_ps_data
  File.open(File.join(Rails.root, 'spec', 'support', 'get_mits_property_units_for_63780_67741_63705_67530_67934_1.json')) do |f|
    JSON.parse(f.read)['response']['result']['PhysicalProperty']['Property']
  end
end

def import_data_for_ps_tests
  test_ps_data[0..0].each do |raw|
    PropertySolutions::Import::Update.update PropertySolutions::Import::Property.new(raw)
  end
end

def prepare_data
  import_data_for_ps_tests

  @property = Property.find_by_gables_id('63780')
  @floorplan = @property.floorplans.first
  @floorplan2 = @property.floorplans.second

  @unit = @floorplan.units.first

  # modifing objects to be from vaultware
  [@property, @floorplan, @unit].each do |e|
    e.use_propertysolutions_data = false
    e.save
    e.update_attributes :from_vaultware => true, :name => "#{e.class.name} from VaultWare"
    e.backup_vaultware_data
    e.save
  end



  import_data_for_ps_tests


  #modifing object to be not from vaultware and not from propertysolutions
  @floorplan2.use_propertysolutions_data = false
  @floorplan2.from_propertysolutions = false
  @floorplan2.backup_vaultware_data
  @floorplan2.save
end

describe 'property solutions switch' do

  before :all do
    Image.send :define_method, :remote_image_url= do |p|
    end
    prepare_data
  end


  context 'use_propertysolutions_data false' do
    it 'uses VW data' do
      [@property, @floorplan, @unit].each do |e|
        e.name.should eq("#{e.class.name} from VaultWare")
      end
    end

    context 'from_vaultware is true' do
      it 'associations loads only VW objects' do
        @property.floorplans.size.should eq(1)
        @property.floorplans.find{ |f| f.gables_id == @floorplan.gables_id }.should_not be_nil
        @property.floorplans.find{ |f| f.gables_id == @floorplan2.gables_id }.should be_nil

        @floorplan.units.size.should eq(1)
        @floorplan.units.first.gables_id.should eq(@unit.gables_id)
      end
    end

    context 'from_vaultware false and from_propertysolutions false' do

      before :each do
        @property.from_vaultware = false
        @property.from_propertysolutions = false
      end

      it 'associations loads objects from VW, PS and other' do
        @property.floorplans.find{ |f| f.gables_id == @floorplan.gables_id }.should_not be_nil
        @property.floorplans.find{ |f| f.gables_id == @floorplan2.gables_id }.should_not be_nil
      end
    end

  end

  context 'use_propertysolutions_data true and from_propertysolutions true' do
    before :all do
      @property.use_propertysolutions_data = true
      @property.from_propertysolutions = true
      @property.save
    end

    it 'uses PS data' do
      [@property, @floorplan, @unit].each do |e|
        e.reload.name.should_not eq("#{e.class.name} from VaultWare")
        e.reload.name.should_not be_nil
      end
    end

    it 'loads PS objects only' do
      @property.floorplans.size.should_not eq(1)
      @property.floorplans.find{ |f| f.gables_id == @floorplan.gables_id }.should_not be_nil
      @property.floorplans.find{ |f| f.gables_id == @floorplan2.gables_id }.should be_nil

      @floorplan.units.size.should_not eq(1)
      @floorplan.units.find{ |u| u.gables_id == @unit.gables_id }.should_not be_nil
    end


  end

end
