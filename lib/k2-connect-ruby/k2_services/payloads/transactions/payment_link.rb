# frozen_string_literal: true

module K2ConnectRuby
  module K2Services
    module Payloads
      module Transactions
        # Parsed attributes of payment link result callback
        class PaymentLink
          include ActiveModel::Validations

          attr_reader :id, :type, :status, :created_at, :till_name, :currency, :amount, :payment_reference, :note,
            :payment_link, :request_errors, :metadata, :callback_url, :links_self

          validates :id, :type, :status, :created_at, :till_name, :currency, :amount, :callback_url, :links_self,
            presence: :true
          validates :type, comparison: { equal_to: "payment_link" }

          def initialize(payload)
            @id = payload.dig("data", "id")
            @type = payload.dig("data", "type")
            @status = payload.dig("data", "attributes", "status")
            @created_at = payload.dig("data", "attributes", "created_at")
            @till_name = payload.dig("data", "attributes", "till_name")
            @currency = payload.dig("data", "attributes", "currency")
            @amount = payload.dig("data", "attributes", "amount")
            @payment_reference = payload.dig("data", "attributes", "payment_reference")
            @note = payload.dig("data", "attributes", "note")
            @payment_link = payload.dig("data", "attributes", "payment_link")&.deep_symbolize_keys
            @metadata = payload.dig("data", "attributes", "metadata")&.deep_symbolize_keys
            @request_errors = payload.dig("data", "attributes", "errors")
            @callback_url = payload.dig("data", "attributes", "_links", "callback_url")
            @links_self = payload.dig("data", "attributes", "_links", "self")
          end
        end
      end
    end
  end
end
