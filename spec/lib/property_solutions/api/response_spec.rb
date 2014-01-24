module PropertySolutions
  module API
    describe Response do
      let(:http_response) { '{"response":{"requestId":"15","result":"result"}}' }
      let(:resp) { API::Response.new http_response }
      it 'stores http response' do
        resp.instance_variable_get('@http_response').should eq('{"response":{"requestId":"15","result":"result"}}')
      end
      it 'get needed data from http response' do
        resp.result.should eq('result')
      end
    end
  end
end

