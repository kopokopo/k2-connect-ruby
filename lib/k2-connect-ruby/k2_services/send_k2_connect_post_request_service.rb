# frozen_string_literal: true

module K2ConnectRuby
  module K2Services
    class SendK2ConnectPostRequestService < BaseService
      include K2ConnectRuby::K2Utilities::K2ConnectionHelper

      attr_reader :access_token, :endpoint, :request_body

      def initialize(access_token, endpoint, request_body)
        super()
        @access_token = access_token
        @endpoint = endpoint
        @request_body = request_body
      end

      def execute
        send_request
      end

      private

      def send_request
        response = K2ConnectRuby::HttpClient.post(
          endpoint,
          payload: request_body.to_json,
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

      def request_headers
        { "Content-Type" => "application/json", "Accept" => "application/json", Authorization: "Bearer #{access_token}", "User-Agent" => "Kopokopo-Ruby-SDK" }
      end
    end
  end
end
