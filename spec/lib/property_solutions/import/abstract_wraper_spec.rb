require 'spec_helper'


module PropertySolutions
  module Import
    describe AbstractWraper do
      it 'converts to symbol demodulized name of class' do
        AbstractWraper.to_sym.should eq(:abstractwraper)
      end

      it 'stores source when instantiated' do
        property = AbstractWraper.new 'source'# {'a' => {'b' => {'c' => 'result'}}}
        property.instance_variable_get('@source').should eq('source')
      end
      it 'gets value from source by path' do
        property = AbstractWraper.new({'a' => {'b' => {'c' => 'result', 'd' => [4, 5, 6], 'e' => [{'f' => {'g' => '1'}, 'h' => 5},{'f' => {'g' =>'2'}, 'h' => '8'}]}}})
        property.get_value('a/b/c').should eq('result')
        property.get_value('a/b/d/1').should eq(5)
        property.get_value('a/b/e[f\g=1]/0/h').should eq(5)

        property.stub(:private_attribute).and_return('c')
        property.get_value('a/b/{#private_attribute}').should eq('result')
      end

      it 'maps attribute reader to specified value in source' do
        property = AbstractWraper.new({'a' => {'b' => {'c' => '7'}}})
        AbstractWraper.map 'test', 'a/b/c', :integer
        property.test.should eq(7)
      end

      it 'when inherited creates attr readers specified in mappings for descendant' do
        MAPPING[:testobj] = {:mapped_attr_reader => ['path', :text]}
        class TestObj < AbstractWraper; end
        TestObj.new('').methods.should include(:mapped_attr_reader)
      end

      it 'groups attributes by type when maps' do
        attrs = {
          :city => ['PropertyID/Address/City', :text, :private],
          :state => ['PropertyID/Address/State', :text],
          :zip => ['PropertyID/Address/PostalCode', :text, :association]
        }

        AbstractWraper.map_attributes attrs

        AbstractWraper.attributes.should include(:state)
        AbstractWraper.private_attributes.should include(:city)
        AbstractWraper.associations.should include(:zip)
      end

      it 'returns hash of attributes' do
        obj = AbstractWraper.new('')
        AbstractWraper.stub(:attributes).and_return([:a,:b,:c])
        obj.stub(:a).and_return(1)
        obj.stub(:b).and_return(2)
        obj.stub(:c).and_return(3)
        
        obj.attributes.should eq({:a => 1, :b => 2, :c => 3})
      end
      it 'returns hash of associations' do
        obj = AbstractWraper.new('')
        AbstractWraper.stub(:associations).and_return([:a,:b,:c])
        obj.stub(:a).and_return(1)
        obj.stub(:b).and_return(2)
        obj.stub(:c).and_return(3)
        
        obj.associations.should eq({:a => 1, :b => 2, :c => 3})
      end


      describe 'typecasters' do
        let(:abstract_wraper) { AbstractWraper.new('') }
        it 'typecasts value to integer' do
          abstract_wraper._integer('5').should eq(5)
        end

        it 'typecasts value to decimal' do
          abstract_wraper._decimal('5.1').should eq(5.1)
        end

        xit 'typecasts value to date' do
          abstract_wraper._date('22.05.2013').should eq('date')
        end

        it 'typecasts value to boolean' do
          abstract_wraper._boolean('').should eq(false)
          abstract_wraper._boolean(nil).should eq(false)
          abstract_wraper._boolean('1').should eq(true)
        end

        it 'typecasts value to text' do
          abstract_wraper._text('text').should eq('text')
        end
        
        it 'typecasts value to images' do
          Import::Image.should_receive(:new).twice
          abstract_wraper._images(%w{a b})
        end
        
      end

    end

  end
end
