# frozen_string_literal: true

module K2ConnectRuby
  module K2Entity
    module K2FinancialEntities
      module Reversals
        # Request to initiate a reversal
        class ReversalRequest
          include ActiveModel::Validations

          attr_accessor :transaction_reference, :reason, :metadata, :callback_url

          validates :transaction_reference, :reason, :callback_url, presence: true

          def initialize(kwargs)
            kwargs.each do |key, value|
              instance_variable_set("@#{key}", value)
            end
          end

          def request_body
            {
              transaction_reference: transaction_reference,
              reason: reason,
              metadata: metadata,
              _links: {
                callback_url: callback_url
              }
            }
          end

          def endpoint
            K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("reversals")
          end
        end
      end
    end
  end
end
