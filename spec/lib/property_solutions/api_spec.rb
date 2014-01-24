require 'spec_helper'

module PropertySolutions
  describe API do
    it 'gets properies' do
      req = mock :api_request
      resp = mock :api_re
      API::Request.should_receive(:new).with('getProperties').and_return(req)
      API.should_receive(:get_data).with(req)
      API.get_properties
    end
    it 'gets property units' do
      req = mock :api_request
      API::Request.should_receive(:new).with('getMitsPropertyUnits', :propertyIds => '1,2,3', :avalibleUnitsOnly => '1').and_return(req)
      API.should_receive(:get_data).with(req)
      API.get_property_units '1,2,3', true
    end

    it 'gets data from api request' do
      api_resp = mock :api_response, :result => 'request result'
      api_req = mock :api_req
      API.should_receive(:execute).with(api_req).and_return api_resp
      API.get_data(api_req).should eq('request result')
    end

    it 'executes api request and returns api response' do
      req = mock :api_request
      api_resp = mock :api_resp
      req.should_receive(:execute).and_return(:http_resp_body)
      API::Response.should_receive(:new).with(:http_resp_body).and_return(api_resp)
      API.execute(req).should eq(api_resp)
    end

  end

end
