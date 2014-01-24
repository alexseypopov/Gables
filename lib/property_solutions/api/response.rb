module PropertySolutions
  module API
    class Response
      def initialize http_resp
        @http_response = http_resp
      end

      def body
        @body ||= JSON.parse @http_response
      end

      def result
        body['response']['result']
      end
    end
  end
end
