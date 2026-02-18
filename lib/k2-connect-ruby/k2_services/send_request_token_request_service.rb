# frozen_string_literal: true

module K2ConnectRuby
  module K2Services
    class SendRequestTokenRequestService < BaseService
      include K2ConnectRuby::K2Utilities::K2ConnectionHelper

      attr_reader :client_id, :client_secret

      def initialize(client_id, client_secret)
        super()
        @client_id = client_id
        @client_secret = client_secret
      end

      def execute
        send_request
      end

      private

      def send_request
        response = K2ConnectRuby::HttpClient.post(
          endpoint,
          payload: request_body_json,
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
        K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("oauth_token")
      end

      def request_headers
        { "Content-Type" => "application/json", "Accept" => "application/json", "User-Agent" => "Kopokopo-Ruby-SDK" }
      end

      def request_body_json
        {
          client_id: client_id,
          client_secret: client_secret,
          grant_type: "client_credentials",
        }.to_json
      end
    end
  end
end
