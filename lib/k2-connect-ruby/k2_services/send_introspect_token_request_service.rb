# frozen_string_literal: true

module K2ConnectRuby
  module K2Services
    class SendIntrospectTokenRequestService < BaseService
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
        response = K2ConnectRuby::HttpClient.post(
          endpoint,
          payload: params.to_json,
          headers: request_headers
        )

        CallResult.success(
          {
            response_code: response.code,
            response_headers: response_headers(response.headers),
            response_body: response_body(response.body),
          },
        )
      end

      def endpoint
        K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("introspect_token")
      end

      def params
        {
          client_id: client_id,
          client_secret: client_secret,
          token: access_token,
        }
      end

      def request_headers
        { "Content-Type" => "application/json", "Accept" => "application/json", "User-Agent" => "Kopokopo-Ruby-SDK" }
      end
    end
  end
end
