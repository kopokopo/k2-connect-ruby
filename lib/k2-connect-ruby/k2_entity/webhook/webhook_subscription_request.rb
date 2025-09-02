# frozen_string_literal: true

module K2ConnectRuby
  module K2Entity
    module K2FinancialEntities
      module Webhook
        class WebhookSubscriptionRequest
          include ActiveModel::Validations

          attr_accessor :event_type, :url, :scope, :scope_reference

          validates :event_type, :url, :scope, presence: true
          validates :scope_reference, presence: true, if: :till_scope?
          validates :event_type, inclusion: {
            in: [
              "buygoods_transaction_received",
              "b2b_transaction_received",
              "settlement_transfer_completed",
              "customer_created",
              "buygoods_transaction_reversed",
              "card_transaction_received",
              "card_transaction_voided",
              "card_transaction_reversed"
            ],
            message: "is invalid",
          }
          validates :scope, inclusion: {
            in: ["till", "company"],
            message: "must be one of 'till' or 'company'.",
          }

          def initialize(kwargs)
            kwargs.each do |key, value|
              instance_variable_set("@#{key}", value)
            end
          end

          def endpoint
            K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("webhook_subscriptions")
          end

          def request_body
            {
              event_type: event_type,
              url: url,
              scope: scope,
              scope_reference: scope_reference,
            }
          end

          def till_scope?
            scope == "till"
          end
        end
      end
    end
  end
end
