# frozen_string_literal: true

# Class for collecting destination details for external paybills

module K2ConnectRuby
  module K2Entity
    module K2FinancialEntities
      module Destination
        class ExternalPaybill < DestinationRequest
          include ActiveModel::Validations

          attr_accessor :paybill_number, :paybill_account_number

          validates :paybill_number, :paybill_account_number, :description, presence: true

          def destination_payload
            {
              type: type,
              nickname: nickname,
              paybill_number: paybill_number,
              paybill_account_number: paybill_account_number,
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
