# frozen_string_literal: true

module K2ConnectRuby
  module K2Services
    module Payloads
      module Transactions
        # Parsed attributes of reversal result callback
        class Reversal
          include ActiveModel::Validations

          attr_reader :id, :type, :transaction_reference, :reason, :status, :created_at, :reversal_bulk_payment,
            :request_errors, :metadata, :callback_url, :links_self

          validates :id, :type, :transaction_reference, :reason, :status, :created_at, :callback_url, :links_self,
            presence: true
          validates :type, comparison: { equal_to: "reversal" }

          def initialize(payload)
            @id = payload.dig("data", "id")
            @type = payload.dig("data", "type")
            @transaction_reference = payload.dig("data", "attributes", "transaction_reference")
            @status = payload.dig("data", "attributes", "status")
            @created_at = payload.dig("data", "attributes", "created_at")
            @reason = payload.dig("data", "attributes", "reason")
            @reversal_bulk_payment = payload.dig("data", "attributes", "reversal_bulk_payment")&.deep_symbolize_keys
            @metadata = payload.dig("data", "attributes", "metadata")&.deep_symbolize_keys
            @request_errors = payload.dig("data", "attributes", "errors")
            @links_self = payload.dig("data", "attributes", "_links", "self")
            @callback_url = payload.dig("data", "attributes", "_links", "callback_url")
          end
        end
      end
    end
  end
end
