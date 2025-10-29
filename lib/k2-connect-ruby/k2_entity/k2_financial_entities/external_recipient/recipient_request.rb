# frozen_string_literal: true

module K2ConnectRuby
  module K2Entity
    module K2FinancialEntities
      module ExternalRecipient
        class RecipientRequest
          include ActiveModel::Validations

          attr_accessor :type, :nickname

          def initialize(kwargs)
            kwargs.each do |key, value|
              instance_variable_set("@#{key}", value)
            end
          end

          def endpoint
            K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("pay_recipient")
          end

          def request_body
            {
              type: type,
              pay_recipient: self.as_json
            }
          end
        end
      end
    end
  end
end
