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

          validates :id, :type, :transaction_reference, :reason, :status, :created_at, :callback_url, :link_self,
                    presence: true

          def initialize(payload)
            @id = payload["id"]
            @type = payload["type"]
            @transaction_reference = payload["attributes"]["transaction_reference"]
            @status = payload.dig("attributes", "status")
            @created_at = payload.dig("attributes", "created_at")
            @reason = payload.dig("attributes", "reason")
            @reversal_bulk_payment = payload.dig("attributes", "reversal_bulk_payment")&.deep_symbolize_keys
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
