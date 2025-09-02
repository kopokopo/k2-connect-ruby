# frozen_string_literal: true

# Common Class Behaviours for stk, pay and transfers
module K2ConnectRuby
  module K2Entity
    class K2Entity
      attr_accessor :access_token
      attr_reader :k2_response_body, :query_hash, :location_url

      include K2ConnectRuby::K2Utilities

      # Initialize with access token from Subscriber Class
      def initialize(access_token)
        @access_token = access_token
      end

      # Query/Check the status of a previously initiated request
      def query_status(endpoint)
        query(endpoint)
      end

      # Query Location URL
      def query_resource(endpoint)
        query(endpoint)
      end

      def query(endpoint)
        result = K2ConnectRuby::K2Services::SendK2ConnectGetRequestService.call(access_token, endpoint)
        if result.success?
          @k2_response_body = result.data[:response_body]
        else
          raise(result.errors.first)
        end
      end
    end
  end
end
