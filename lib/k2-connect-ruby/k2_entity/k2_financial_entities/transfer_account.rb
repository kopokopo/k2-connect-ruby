# frozen_string_literal: true

# Adding either one's own bank account or M-PESA phone
module K2ConnectRuby
  module K2Entity
    class TransferAccount < K2ConnectRuby::K2Entity::K2Entity
      attr_accessor :transfer_account_location_url

      def add_transfer_account(params)
        params = params.with_indifferent_access
        transfer_account = build_transfer_account(params)
        raise(ArgumentError, transfer_account.errors.full_messages.first) unless transfer_account.valid?

        result = K2ConnectRuby::K2Services::SendK2ConnectPostRequestService.call(
          access_token,
          transfer_account.endpoint,
          transfer_account.request_body,
        )
        if result.success?
          @transfer_account_location_url = result.data[:response_headers][:location]
        else
          raise(result.errors.first)
        end
      end

      # Query/Check the status of a recently initiated Send money request
      def query_status
        super(transfer_account_location_url)
      end

      # Query specific URL
      def query_resource(url)
        super(url)
      end

      private

      def build_transfer_account(params)
        if params[:type].eql?("merchant_wallet")
          K2ConnectRuby::K2Entity::K2FinancialEntities::TransferAccount::MerchantMpesaWallet.new(params)
        elsif params[:type].eql?("merchant_bank_account")
          K2ConnectRuby::K2Entity::K2FinancialEntities::TransferAccount::MerchantBankAccount.new(params)
        else
          raise(ArgumentError, "Unknown transfer account type.")
        end
      end
    end
  end
end
