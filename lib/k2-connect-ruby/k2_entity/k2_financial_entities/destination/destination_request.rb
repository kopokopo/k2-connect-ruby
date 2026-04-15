# frozen_string_literal: true

module K2ConnectRuby
  module K2Entity
    module K2FinancialEntities
      module Destination
        class DestinationRequest
          include ActiveModel::Validations

          attr_accessor :type, :nickname, :amount, :description, :favourite

          validates :type, :amount, presence: true
          validates :favourite, inclusion: { in: [true, false, 'true', 'false', 1, 0, 'T', 'F'],
                                             message: 'is not a valid boolean' }, if: -> { favourite.present? }

          def initialize(kwargs)
            kwargs.each do |key, value|
              instance_variable_set("@#{key}", value)
            end
          end

          def destination_payload; end
        end
      end
    end
  end
end
