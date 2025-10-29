# frozen_string_literal: true

module K2ConnectRuby
  module K2Entity
    class K2Stk < K2ConnectRuby::K2Entity::K2Entity
      # Receive payments from M-PESA users.
      def send_stk_request(params)
        stk_push_request = K2ConnectRuby::K2Entity::K2FinancialEntities::StkPush::StkPushRequest.new(params)
        raise(ArgumentError, stk_push_request.errors.full_messages.first) unless stk_push_request.valid?

        result = K2ConnectRuby::K2Services::SendK2ConnectPostRequestService.call(
          access_token,
          stk_push_request.endpoint,
          stk_push_request.request_body,
        )
        if result.success?
          @location_url = result.data[:response_headers][:location]
        else
          raise(result.errors.first)
        end
      end

      # Query/Check STK Payment Request Status
      def query_status
        super(location_url)
      end

      # Query Location URL
      def query_resource(url)
        super(url)
      end
    end
  end
end
