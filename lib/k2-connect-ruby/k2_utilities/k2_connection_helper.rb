# frozen_string_literal: true

module K2ConnectRuby
  module K2Utilities
    module K2ConnectionHelper
      extend self

      def rest_client_errors(ex)
        JSON.parse(ex.response.body)&.dig("errors")
      end
    end
  end
end
