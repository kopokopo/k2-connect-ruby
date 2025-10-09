# frozen_string_literal: true

module K2ConnectRuby
  module K2Services
    class SendRevokeTokenRequestService < BaseService
      include K2ConnectRuby::K2Utilities::K2ConnectionHelper

      attr_reader :client_id, :client_secret, :access_token

      def initialize(client_id, client_secret, access_token)
        super()
        @client_id = client_id
        @client_secret = client_secret
        @access_token = access_token
      end

      def execute
        send_request
      end

      private

      def send_request
        resource = RestClient::Resource.new(endpoint, open_timeout: 5, read_timeout: 10, headers: request_headers)
        response = resource.post(params.to_json)
        CallResult.success(
          {
            response_code: response.code,
            response_headers: JSON.parse(response.headers.to_json, symbolize_names: true),
            response_body: JSON.parse(response.body, symbolize_names: true),
          },
        )
      rescue RestClient::Exception => ex
        CallResult.errors(rest_client_errors(ex))
      rescue Errno::ECONNREFUSED => ex
        CallResult.errors(["Connection refused"])
      rescue StandardError => ex
        CallResult.errors([ex.message])
      end

      def endpoint
        K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("revoke_token")
      end

      def params
        {
          client_id: client_id,
          client_secret: client_secret,
          access_token: access_token,
        }
      end

      def request_headers
        { "Content-Type" => "application/json", "Accept" => "application/json", "User-Agent" => "Kopokopo-Ruby-SDK" }
      end
    end
  end
end
