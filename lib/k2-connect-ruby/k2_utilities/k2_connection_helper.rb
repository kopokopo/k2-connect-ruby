# frozen_string_literal: true

module K2ConnectRuby
  module K2Utilities
    module K2ConnectionHelper
      extend self

      def rest_client_error(ex)
        ex.response.present? ? JSON.parse(ex.response.body) : {}
      end

      def response_headers(headers)
        headers.blank? ? {} : JSON.parse(headers.to_json, symbolize_names: true)
      end

      def response_body(body)
        body.blank? ? {} : JSON.parse(body, symbolize_names: true)
      end
    end
  end
end
