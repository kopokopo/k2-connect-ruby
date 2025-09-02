# frozen_string_literal: true

module K2ConnectRuby
  module K2Entity
    module K2FinancialEntities
      module StkPush
        class StkPushRequest
          include ActiveModel::Validations

          attr_accessor :till_number, :payment_channel, :first_name, :middle_name, :last_name, :phone_number, :email, :amount, :callback_url, :metadata

          validates :till_number, :phone_number, :amount, :callback_url, presence: true

          validates_with K2ConnectRuby::K2Utilities::PhoneNumberValidator

          def initialize(kwargs)
            kwargs.each do |key, value|
              instance_variable_set("@#{key}", value)
            end
          end

          def endpoint
            K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("incoming_payments")
          end

          def request_body
            {
              payment_channel: payment_channel,
              till_number: till_number,
              subscriber: {
                first_name: first_name,
                middle_name: middle_name,
                last_name: last_name,
                phone_number: phone_number,
                email: email,
              },
              amount: {
                currency: "KES",
                value: amount,
              },
              metadata: metadata,
              _links: {
                callback_url: callback_url,
              },
            }
          end
        end
      end
    end
  end
end
