# frozen_string_literal: true

# Class for collecting destination details for external M-PESA numbers

module K2ConnectRuby
  module K2Entity
    module K2FinancialEntities
      module Destination
        class ExternalMpesaWallet < DestinationRequest
          include ActiveModel::Validations

          attr_accessor :phone_number, :network

          validates :phone_number, :description, presence: true
          validate :phone_number_format

          def destination_payload
            {
              type: type,
              nickname: nickname,
              phone_number: phone_number,
              network: network,
              amount: amount,
              description: description,
              favourite: ActiveModel::Type::Boolean.new.cast(favourite),
            }
          end

          def phone_number_format
            unless phone_number&.match?(/^(254\d{9})$/)
              errors.add(:phone_number, "#{phone_number} has an invalid length or format. Must be 254XXXXXXXXX.")
            end
          end
        end
      end
    end
  end
end
