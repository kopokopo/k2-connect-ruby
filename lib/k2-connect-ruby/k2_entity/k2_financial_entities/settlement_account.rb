# frozen_string_literal: true

# Adding either one's own bank account or M-PESA phone
module K2ConnectRuby
  module K2Entity
    class SettlementAccount < K2ConnectRuby::K2Entity::K2Entity
      attr_accessor :settlement_account_location_url

      def add_settlement_account(params)
        params = params.with_indifferent_access
        settlement_account = build_settlement_account(params)
        raise(ArgumentError, settlement_account.errors.full_messages.first) unless settlement_account.valid?

        result = K2ConnectRuby::K2Services::SendK2ConnectPostRequestService.call(
          access_token,
          settlement_account.endpoint,
          settlement_account.request_body,
        )
        if result.success?
          @settlement_account_location_url = result.data[:response_headers][:location]
        else
          raise(result.errors.first)
        end
      end

      # Query/Check the status of a recently initiated Send money request
      def query_status
        super(settlement_account_location_url)
      end

      # Query specific URL
      def query_resource(url)
        super(url)
      end

      private

      def build_settlement_account(params)
        if params[:type].eql?("merchant_wallet")
          K2ConnectRuby::K2Entity::K2FinancialEntities::SettlementAccount::MerchantMpesaWallet.new(params)
        elsif params[:type].eql?("merchant_bank_account")
          K2ConnectRuby::K2Entity::K2FinancialEntities::SettlementAccount::MerchantBankAccount.new(params)
        else
          raise(ArgumentError, "Unknown settlement account type.")
        end
      end
    end
  end
end
