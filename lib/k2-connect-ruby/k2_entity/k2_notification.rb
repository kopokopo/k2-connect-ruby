# frozen_string_literal: true

module K2ConnectRuby
  module K2Entity
    class K2Notification
      include K2ConnectRuby::K2Utilities
      attr_reader :location_url, :k2_response_body
      attr_accessor :access_token

      # Initialize with access_token
      def initialize(access_token)
        raise ArgumentError, "Nil or Empty Access Token Given!" if access_token.blank?

        @access_token = access_token
      end

      # Sends transaction notifications via SMS
      def send_sms_transaction_notification(params)
        notification_request = K2ConnectRuby::K2Entity::K2FinancialEntities::Notification::NotificationRequest.new(params)
        raise(ArgumentError, notification_request.errors.full_messages.first) unless notification_request.valid?

        result = K2ConnectRuby::K2Services::SendK2ConnectPostRequestService.call(
          access_token,
          notification_request.endpoint,
          notification_request.request_body,
        )
        if result.success?
          @location_url = result.data[:response_headers][:location]
        else
          raise(result.errors.first)
        end
      end

      # Query Recent Webhook
      def query_resource(location_url = @location_url)
        result = K2ConnectRuby::K2Services::SendK2ConnectGetRequestService.call(access_token, @location_url)
        if result.success?
          @k2_response_body = result.data[:response_body]
        else
          raise(result.errors.first)
        end
      end

      # Query Specific Webhook URL
      def query_resource_url(url)
        query_resource(url)
      end
    end
  end
end
