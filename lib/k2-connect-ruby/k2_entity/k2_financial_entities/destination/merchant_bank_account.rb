# frozen_string_literal: true

# Class for collecting destination details for my bank account

module K2ConnectRuby
  module K2Entity
    module K2FinancialEntities
      module Destination
        class MerchantBankAccount < DestinationRequest
          include ActiveModel::Validations

          attr_accessor :reference

          validates :reference, presence: true

          def destination_payload
            {
              type: type,
              reference: reference,
              amount: amount,
            }
          end
        end
      end
    end
  end
end
