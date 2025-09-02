# frozen_string_literal: true

module K2ConnectRuby
  module K2Entity
    module K2FinancialEntities
      module Notification
        class NotificationRequest
          include ActiveModel::Validations

          attr_accessor :webhook_event_reference, :message, :callback_url

          validates :webhook_event_reference, :message, :callback_url, presence: true

          def initialize(kwargs)
            kwargs.each do |key, value|
              instance_variable_set("@#{key}", value)
            end
          end

          def endpoint
            K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("transaction_sms_notifications")
          end

          def request_body
            {
              webhook_event_reference: webhook_event_reference,
              message: message,
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
