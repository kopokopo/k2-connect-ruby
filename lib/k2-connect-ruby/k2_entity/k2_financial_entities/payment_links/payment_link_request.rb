# frozen_string_literal: true

module K2ConnectRuby
  module K2Entity
    module K2FinancialEntities
      module PaymentLinks
        # Request to create a payment link
        class PaymentLinkRequest
          include ActiveModel::Validations

          attr_accessor :till_number, :currency, :amount, :payment_reference, :note, :metadata, :callback_url

          validates :till_number, :currency, :amount, :callback_url, presence: true
          validates :currency, inclusion: { in: ["KES"], message: "must be 'KES'" }

          def initialize(kwargs)
            kwargs.each do |key, value|
              instance_variable_set("@#{key}", value)
            end
          end

          def request_body
            {
              till_number: till_number,
              currency: currency,
              amount: amount,
              payment_reference: payment_reference,
              note: note,
              metadata: metadata,
              callback_url: callback_url
            }
          end

          def endpoint
            K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("payment_links")
          end
        end
      end
    end
  end
end
