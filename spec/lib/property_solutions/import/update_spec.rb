require 'spec_helper'

module PropertySolutions
  module Import
    describe Update do

      it 'updates subject according to raw record' do
        raw = mock :raw, :attributes => :attributes, :associations => :associations
        subj = mock :subj
        Import::Update.should_receive(:fetch).with(raw).and_return(subj)
        Import::Update.should_receive(:update_attributes).with(subj, :attributes)
        Import::Update.should_receive(:update_associations).with(subj, :associations)
        subj.should_receive(:save!)

        Import::Update.update(raw).should eq(subj)
      end
      it 'fetches update subject wih appropriate finder' do
        property = Import::Property.new('')
        property.stub(:gables_id).and_return(1)

        ::Property.should_receive(:find_or_initialize_by_gables_id).with(1)
        Import::Update.fetch property

        floorplan = Import::Floorplan.new('')
        floorplan.stub(:gables_id).and_return(1)

        ::Floorplan.should_receive(:find_or_initialize_by_gables_id).with(1)
        Import::Update.fetch floorplan

        unit = Import::Unit.new('')
        unit.stub(:gables_id).and_return(1)

        ::Unit.should_receive(:find_or_initialize_by_gables_id).with(1)
        Import::Update.fetch unit

      end

      
      it 'upadtes all associations of subject' do
        associations = {:a1 => :values, :a2 => :values}
        subj = mock :property
        Import::Update.should_receive(:update_association).with(subj, :a1, :values) 
        Import::Update.should_receive(:update_association).with(subj, :a2, :values)

        Import::Update.update_associations subj, associations
      end

      it 'updates subjects association' do
        fp1 = mock :fp1, :attributes => :attributes1, :associations => :associations1
        fp2 = mock :fp2, :attributes => :attributes2, :associations => :associations2
        association = {:floorplans => [fp1, fp2]}
        subj = mock :property
        Import::Update.should_receive(:update).with(fp1).and_return(:fetched_fp1)
        Import::Update.should_receive(:update).with(fp2).and_return(:fetched_fp2)

        subj.should_receive(:"floorplans=").with([:fetched_fp1, :fetched_fp2])


        Import::Update.update_association subj, :floorplans, association[:floorplans]
      end

      it 'updates subjects scoped association' do
        a1 = mock :a1, :attributes => :attributes1, :associations => :associations1
        a2 = mock :a2, :attributes => :attributes2, :associations => :associations2
        association = {:amenities => [a1, a2]}
        subj = mock :property, :amenities => :amenities_relation
        Import::Update.should_receive(:update).with(a1, :amenities_relation).and_return(:fetched_a1)
        Import::Update.should_receive(:update).with(a2, :amenities_relation).and_return(:fetched_a2)

        subj.should_receive(:"amenities=").with([:fetched_a1, :fetched_a2])


        Import::Update.update_association subj, :amenities, association[:amenities]

      end

      describe '.update_attributes' do
        let(:subj) { ::Property.new }
        it 'updates subjects attributes' do
          attributes = {:city => 123, :name => 'property' }
          Import::Update.update_attributes subj, attributes
          subj.city.should eq(123)
          subj.name.should eq('property')
        end
        it 'sets "from_propertysolutions" flag to subject' do
          attributes = {:city => 123, :name => 'property' }
          Import::Update.update_attributes subj, attributes
          subj.from_propertysolutions.should be_true
        end
        context 'subject is Image' do
          let(:subj) { ::Image.new }
          let(:attributes) { {:propertysolutions_url => 'some_url'} }
          context 'subject is new record' do
            it 'sets retrived image url to remote_image_url' do
              subj.should_receive(:remote_image_url=).with('some_url')
              Import::Update.update_attributes subj, attributes
            end
          end
          context 'image does not have uploaded file' do
            before do
              subj.stub(:path).and_return('some_path')
              File.stub(:exists?).with('some_path').and_return(false)
            end
            it 'sets retrived image url to remote_image_url' do
              subj.should_receive(:remote_image_url=).with('some_url')
              Import::Update.update_attributes subj, attributes
            end
          end
        end
      end

    end
  end
end
