module PropertySolutions
  module API

    class Request

      def initialize method_name, params={}
        @method_name = method_name
        @params = params
      end

      def domain
        "#{CONFIG[:domain]}.propertysolutions.com"
      end

      def endpoint
        CONFIG[:methods_urls][@method_name]
      end

      def body
        {
          :auth => {
            :type => 'basic',
            :password => CONFIG[:password],
            :username => CONFIG[:username]
          },
          :requestId => '15',
          :method =>{
            :name => @method_name,
            :params => @params
          }
        }.to_json
      end

      def headers
        { 'Content-Type' => 'APPLICATION/JSON; CHARSET=UTF-8' }
      end

      def execute
        HTTParty.post("https://#{domain}#{endpoint}", :body => body, :headers => headers )
      end

    end
  end
end
