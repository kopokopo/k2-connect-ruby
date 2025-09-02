# Class for collecting destination details for external M-PESA numbers

module K2ConnectRuby
  module K2Entity
    module K2FinancialEntities
      module Destination
        class ExternalMpesaWallet < DestinationRequest
          include ActiveModel::Validations

          attr_accessor :phone_number, :network

          validates :phone_number, :description, presence: true

          validates_with K2ConnectRuby::K2Utilities::PhoneNumberValidator

          def destination_payload
            {
              type: type,
              nickname: nickname,
              phone_number: phone_number,
              network: network,
              amount: amount,
              description: description,
              favourite: favourite,
            }
          end
        end
      end
    end
  end
end
