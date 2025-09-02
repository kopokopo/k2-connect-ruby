# Class for collecting destination details for external till

module K2ConnectRuby
  module K2Entity
    module K2FinancialEntities
      module Destination
        class ExternalTill < DestinationRequest
          include ActiveModel::Validations

          attr_accessor :till_number

          validates :till_number, :description, presence: true

          def destination_payload
            {
              type: type,
              nickname: nickname,
              till_number: till_number,
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
