# frozen_string_literal: true

module K2ConnectRuby
  module K2Services
    module Payloads
      module Webhooks
        class B2bTransactionReceived < K2CommonEvents
          include ActiveModel::Validations

          validates :topic, comparison: { equal_to: "b2b_transaction_received" }

          attr_reader :sending_till,
            :till_number

          def initialize(payload)
            super
            @till_number = payload.dig("event", "resource", "till_number")
            @sending_till = payload.dig("event", "resource", "sending_till")
          end
        end
      end
    end
  end
end
