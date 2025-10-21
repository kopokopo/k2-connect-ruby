# frozen_string_literal: true

module K2ConnectRuby
  module K2Entity
    module K2FinancialEntities
      module Destination
        class DestinationRequest
          include ActiveModel::Validations

          attr_accessor :type, :nickname, :amount, :currency, :description, :favourite

          validates :type, :amount, :currency, presence: true
          validates :currency, inclusion: { in: ["KES"], message: "must be 'KES'." }

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
