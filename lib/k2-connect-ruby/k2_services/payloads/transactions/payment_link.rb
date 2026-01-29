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
          validates :type, comparison: { equal_to: "payment_link"  }

          def initialize(payload)
            @id = payload["id"]
            @type = payload["type"]
            @status = payload.dig("attributes", "status")
            @created_at = payload.dig("attributes", "created_at")
            @till_name = payload.dig("attributes", "till_name")
            @currency = payload.dig("attributes", "currency")
            @amount = payload.dig("attributes", "amount")
            @payment_reference = payload.dig("attributes", "payment_reference")
            @note = payload.dig("attributes", "note")
            @payment_link = payload.dig("attributes", "payment_link")&.deep_symbolize_keys
            @metadata = payload.dig("attributes", "metadata")&.deep_symbolize_keys
            @request_errors = payload.dig("attributes", "errors")
            @callback_url = payload.dig("attributes", "_links", "callback_url")
            @links_self = payload.dig("attributes", "_links", "self")
          end
        end
      end
    end
  end
end
