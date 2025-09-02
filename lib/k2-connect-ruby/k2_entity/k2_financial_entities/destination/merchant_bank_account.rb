# Class for collecting destination details for my bank account

module K2ConnectRuby
  module K2Entity
    module K2FinancialEntities
      module Destination
        class MerchantBankAccount < DestinationRequest
          include ActiveModel::Validations

          attr_accessor :destination_reference

          validates :destination_reference, presence: true

          def destination_payload
            {
              type: type,
              reference: destination_reference,
              amount: amount,
            }
          end
        end
      end
    end
  end
end
