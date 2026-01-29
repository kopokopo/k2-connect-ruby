# frozen_string_literal: true

module K2ConnectRuby
  module K2Entity
    # Service class to initiate or cancel a payment link
    class PaymentLink < K2ConnectRuby::K2Entity::K2Entity
      attr_accessor :payment_link_location_url

      def create_payment_link(params)
        payment_link_request = build_payment_link_request(params)
        raise(ArgumentError, payment_link_request.errors.full_messages.first) unless payment_link_request.valid?

        result = K2ConnectRuby::K2Services::SendK2ConnectPostRequestService.call(
          access_token,
          payment_link_request.endpoint,
          payment_link_request.request_body
        )
        raise(result.errors.first) unless result.success?

        @payment_link_location_url = result.data[:response_headers][:location]
      end

      def cancel_payment_link(resource_url)
        result = K2ConnectRuby::K2Services::SendK2ConnectPostRequestService.call(
          access_token,
          "#{resource_url}/cancel",
          nil
        )
        raise(result.errors.first) unless result.success?

        result.data[:response_body][:message]
      end

      def query_status
        super(payment_link_location_url)
      end

      private

      def build_payment_link_request(params)
        K2ConnectRuby::K2Entity::K2FinancialEntities::PaymentLinks::PaymentLinkRequest.new(
          till_number: params[:till_number],
          currency: params[:currency],
          amount: params[:amount],
          payment_reference: params[:payment_reference],
          note: params[:note],
          metadata: params[:metadata],
          callback_url: params[:callback_url]
        )
      end
    end
  end
end
