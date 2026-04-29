# frozen_string_literal: true

module K2ConnectRuby
  module K2Services
    module Payloads
      class DarajaWebhooks
        include ActiveModel::Validations

        attr_reader :transaction_type,
          :transaction_id,
          :transaction_time,
          :transaction_amount,
          :business_short_code,
          :bill_ref_number,
          :invoice_number,
          :org_account_balance,
          :third_party_transaction_id,
          :msisdn,
          :first_name,
          :middle_name,
          :last_name

        validates :transaction_type, :transaction_id, :transaction_time, :transaction_amount, presence: true

        def initialize(payload)
          @transaction_type = payload.dig("TransactionType")
          @transaction_id = payload.dig("TransID")
          @transaction_time = payload.dig("TransTime")
          @transaction_amount = payload.dig("TransAmount")
          @business_short_code = payload.dig("BusinessShortCode")
          @bill_ref_number = payload.dig("BillRefNumber")
          @invoice_number = payload.dig("InvoiceNumber")
          @org_account_balance = payload.dig("OrgAccountBalance")
          @third_party_transaction_id = payload.dig("ThirdPartyTransId")
          @msisdn = payload.dig("MSISDN")
          @first_name = payload.dig("FirstName")
          @middle_name = payload.dig("MiddleName")
          @last_name = payload.dig("LastName")
        end
      end
    end
  end
end
