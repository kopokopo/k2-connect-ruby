# frozen_string_literal: true

module K2ConnectRuby
  class HttpClient
    def self.post(url, payload:, headers:)
      RestClient.post(url, payload, headers)
    rescue RestClient::Unauthorized
      raise K2ConnectRuby::K2Errors::UnauthorizedError, 'Invalid or expired token'
    rescue RestClient::RequestTimeout
      raise K2ConnectRuby::K2Errors::TimeoutError, 'Request timed out'
    rescue Errno::ECONNREFUSED
      raise K2ConnectRuby::K2Errors::ConnectionError, 'Connection refused'
    rescue RestClient::Exception => e
      body = begin
        JSON.parse(e.response.body)
      rescue StandardError
        nil
      end

      raise K2ConnectRuby::K2Errors::ApiError.new(
        message: body&.dig('error_message') || 'API error',
        code: e.http_code,
        details: body
      )
    end

    def self.get(url, headers:)
      RestClient.get(url, headers)
    rescue RestClient::Unauthorized
      raise K2ConnectRuby::K2Errors::UnauthorizedError, 'Invalid or expired token'
    rescue RestClient::RequestTimeout
      raise K2ConnectRuby::K2Errors::TimeoutError, 'Request timed out'
    rescue Errno::ECONNREFUSED
      raise K2ConnectRuby::K2Errors::ConnectionError, 'Connection refused'
    rescue RestClient::Exception => e
      body = begin
        JSON.parse(e.response.body)
      rescue StandardError
        nil
      end

      raise K2ConnectRuby::K2Errors::ApiError.new(
        message: body&.dig('error_description') || 'API error',
        code: e.http_code,
        details: body
      )
    end
  end
end
