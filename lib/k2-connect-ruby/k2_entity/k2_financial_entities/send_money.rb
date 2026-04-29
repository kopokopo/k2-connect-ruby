# frozen_string_literal: true

# Create a send money request (Either a payment to an external recipient/third party, or transferring funds to ones own accounts).
module K2ConnectRuby
  module K2Entity
    class SendMoney < K2ConnectRuby::K2Entity::K2Entity
      attr_accessor :payments_location_url

      def create_payment(params)
        send_money_request = build_send_money_request(params)
        raise(ArgumentError, send_money_request.errors.full_messages.first) unless send_money_request.valid?

        result = K2ConnectRuby::K2Services::SendK2ConnectPostRequestService.call(
          access_token,
          send_money_request.endpoint,
          send_money_request.request_body,
        )
        if result.success?
          @payments_location_url = result.data[:response_headers][:location]
        else
          raise(result.errors.first)
        end
      end

      # Query/Check the status of a recently initiated Send money request
      def query_status
        super(payments_location_url)
      end

      # Query specific URL
      def query_resource(url)
        super(url)
      end

      private

      def build_send_money_request(params)
        K2ConnectRuby::K2Entity::K2FinancialEntities::SendMoney::SendMoneyRequest.new(
          source_identifier: params[:source_identifier],
          destination_requests: build_destination_requests(params[:destinations]),
          metadata: params[:metadata],
          currency: params[:currency],
          callback_url: params[:callback_url],
        )
      end

      def build_destination_requests(destination_params)
        destination_params&.map do |params|
          build_destination_request(params)
        end
      end

      def build_destination_request(destination_request)
        case destination_request[:type]
        when "mobile_wallet"
          K2ConnectRuby::K2Entity::K2FinancialEntities::Destination::ExternalMpesaWallet.new(destination_request)
        when "bank_account"
          K2ConnectRuby::K2Entity::K2FinancialEntities::Destination::ExternalBankAccount.new(destination_request)
        when "paybill"
          K2ConnectRuby::K2Entity::K2FinancialEntities::Destination::ExternalPaybill.new(destination_request)
        when "till"
          K2ConnectRuby::K2Entity::K2FinancialEntities::Destination::ExternalTill.new(destination_request)
        when "merchant_bank_account"
          K2ConnectRuby::K2Entity::K2FinancialEntities::Destination::MerchantBankAccount.new(destination_request)
        when "merchant_wallet"
          K2ConnectRuby::K2Entity::K2FinancialEntities::Destination::MerchantMpesaWallet.new(destination_request)
        else
          raise(ArgumentError, "Undefined destination type.")
        end
      end
    end
  end
end
