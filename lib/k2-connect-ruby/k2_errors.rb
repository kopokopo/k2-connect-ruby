# frozen_string_literal: true

module K2ConnectRuby

  module K2Errors

    class Error < StandardError; end
    class TimeoutError < Error; end
    class UnauthorizedError < Error; end
    class ConnectionError < Error; end

    class ApiError < Error
      attr_reader :code, :details

      def initialize(message:, code: nil, details: nil)
        @code = code
        @details = details
        super(message)
      end
    end
  end
end
