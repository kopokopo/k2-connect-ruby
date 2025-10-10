# frozen_string_literal: true

module K2ConnectRuby
  module K2Entity
    module K2FinancialEntities
      module TransferAccount
        class TransferAccountRequest
          include ActiveModel::Validations

          attr_accessor :type, :nickname

          def initialize(kwargs)
            kwargs.each do |key, value|
              instance_variable_set("@#{key}", value)
            end
          end

          def endpoint; end

          def request_body; end
        end
      end
    end
  end
end
