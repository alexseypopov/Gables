require 'spec_helper'

module PropertySolutions
  module API
    CONFIG = {
      :username => 'user',
      :password => 'pass',
      :domain => 'test',
      :methods_urls => {
        'getSomething' => 'test'
      }
    }
    describe Request do
      let(:req) { API::Request.new 'getSomething', :criteria => 'query' }
      it 'stores method_name and params on initialize' do
        req.instance_variable_get('@method_name').should eq('getSomething')
        req.instance_variable_get('@params').should eq(:criteria => 'query')
      end

      it 'composes request body' do
        body = JSON.parse(req.body)

        body['auth']['username'].should eq('user')
        body['auth']['password'].should eq('pass')


        body['method']['name'].should eq('getSomething')
        body['method']['params'].should eq({'criteria' => 'query'})
      end

      it 'composes domain for request' do
        CONFIG[:domain] = 'test'
        req.domain.should  eq('test.propertysolutions.com')
      end

      it 'gets endpoint' do
        CONFIG[:methods_urls]['getSomething'] = 'test'
        req.endpoint.should eq('test')
      end


      it 'sends post request to specified endpoint with specified body' do
        req.stub(:body).and_return('body')
        req.stub(:headers).and_return('headers')
        req.stub(:domain).and_return('domain')
        req.stub(:endpoint).and_return('/endpoint')
        HTTParty.should_receive(:post).with('https://domain/endpoint', :body => 'body', :headers => 'headers')
        req.execute
      end
    end
  end
end
