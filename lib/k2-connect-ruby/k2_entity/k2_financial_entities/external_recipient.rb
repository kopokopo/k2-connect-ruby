# frozen_string_literal: true

# Adding external recipients with either mobile_wallets, bank_accounts, till or paybill
module K2ConnectRuby
  module K2Entity
    class ExternalRecipient < K2ConnectRuby::K2Entity::K2Entity
      attr_accessor :recipients_location_url

      def add_external_recipient(params)
        params = params.with_indifferent_access
        external_recipient = build_recipient(params)
        raise(ArgumentError, external_recipient.errors.full_messages.first) unless external_recipient.valid?

        result = K2ConnectRuby::K2Services::SendK2ConnectPostRequestService.call(
          access_token,
          external_recipient.endpoint,
          external_recipient.request_body,
        )
        if result.success?
          @recipients_location_url = result.data[:response_headers][:location]
        else
          raise(result.errors.first)
        end
      end

      # Query/Check the status of a recently initiated Send money request
      def query_status
        super(recipients_location_url)
      end

      # Query specific URL
      def query_resource(url)
        super(url)
      end

      private

      def build_recipient(params)
        case params[:type]
        when "mobile_wallet"
          K2ConnectRuby::K2Entity::K2FinancialEntities::ExternalRecipient::MobileWallet.new(params)
        when "bank_account"
          K2ConnectRuby::K2Entity::K2FinancialEntities::ExternalRecipient::BankAccount.new(params)
        when "till"
          K2ConnectRuby::K2Entity::K2FinancialEntities::ExternalRecipient::Till.new(params)
        when "paybill"
          K2ConnectRuby::K2Entity::K2FinancialEntities::ExternalRecipient::Paybill.new(params)
        else
          raise(ArgumentError, "Undefined payment method.")
        end
      end
    end
  end
end
