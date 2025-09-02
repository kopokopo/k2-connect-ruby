# frozen_string_literal: true

module K2ConnectRuby
  module K2Entity
    class K2Subscribe
      include K2ConnectRuby::K2Utilities
      attr_reader :location_url, :k2_response_body
      attr_accessor :access_token, :webhook_secret

      # Initialize with access token
      def initialize(access_token)
        raise ArgumentError, "Nil or Empty Access Token Given!" if access_token.blank?

        @access_token = access_token
      end

      # Implemented a Case condition that minimises repetition
      def webhook_subscribe(params)
        webhook_subscription_request = K2ConnectRuby::K2Entity::K2FinancialEntities::Webhook::WebhookSubscriptionRequest.new(params)
        raise(ArgumentError, webhook_subscription_request.errors.full_messages.first) unless webhook_subscription_request.valid?

        result = K2ConnectRuby::K2Services::SendK2ConnectPostRequestService.call(
          access_token,
          webhook_subscription_request.endpoint,
          webhook_subscription_request.request_body,
        )
        if result.success?
          @location_url = result.data[:response_headers][:location]
        else
          raise(result.errors.first)
        end
      end

      # Query Recent Webhook
      def query_webhook(location_url = @location_url)
        result = K2ConnectRuby::K2Services::SendK2ConnectGetRequestService.call(access_token, location_url)
        if result.success?
          @k2_response_body = result.data[:response_body]
        else
          raise(result.errors.first)
        end
      end

      # Query Specific Webhook URL
      def query_resource_url(url)
        query_webhook(url)
      end
    end
  end
end
