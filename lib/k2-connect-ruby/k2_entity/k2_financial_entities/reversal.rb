# frozen_string_literal: true

module K2ConnectRuby
  module K2Entity
    # Initiate or get status of a reversal request
    class Reversal < K2ConnectRuby::K2Entity::K2Entity
      attr_accessor :reversal_location_url

      def initiate_reversal(params)
        reversal_request = build_reversal_request(params)
        raise ArgumentError, reversal_request.errors.full_messages.first unless reversal_request.valid?

        result = K2ConnectRuby::K2Services::SendK2ConnectPostRequestService.call(
          access_token,
          reversal_request.endpoint,
          reversal_request.request_body,
        )
        raise(result.errors.first) unless result.success?

        @reversal_location_url = result.data[:response_headers][:location]
      end

      def query_status
        super(reversal_location_url)
      end

      private

      def build_reversal_request(params)
        K2ConnectRuby::K2Entity::K2FinancialEntities::Reversals::ReversalRequest.new(
          transaction_reference: params[:transaction_reference],
          reason: params[:reason],
          metadata: params[:metadata],
          callback_url: params[:callback_url],
        )
      end
    end
  end
end
