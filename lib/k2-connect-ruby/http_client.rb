# frozen_string_literal: true

module K2ConnectRuby
  class HttpClient
    class << self
      def post(url, payload:, headers:)
        request { RestClient.post(url, payload, headers) }
      end

      def get(url, headers:)
        request { RestClient.get(url, headers) }
      end

      private

      def request
        yield
      rescue RestClient::Unauthorized
        raise K2ConnectRuby::K2Errors::UnauthorizedError, "Invalid or expired token"
      rescue RestClient::RequestTimeout
        raise K2ConnectRuby::K2Errors::TimeoutError, "Request timed out"
      rescue RestClient::NotFound
        raise K2ConnectRuby::K2Errors::NotFoundError, "Entity not found"
      rescue Errno::ECONNREFUSED
        raise K2ConnectRuby::K2Errors::ConnectionError, "Connection refused"
      rescue RestClient::Exception => e
        body = parse_body(e)

        raise K2ConnectRuby::K2Errors::ApiError.new(
          message: body&.dig("error_message") || body&.dig("error_description") || "API error",
          code: e.http_code,
          details: body,
        )
      end

      def parse_body(exception)
        JSON.parse(exception.response.body)
      rescue StandardError
        nil
      end
    end
  end
end
