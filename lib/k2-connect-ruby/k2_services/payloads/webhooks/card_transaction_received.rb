module K2ConnectRuby
  module K2Services
    module Payloads
      module Webhooks
        class CardTransactionReceived < K2CommonEvents
          attr_reader :settled, :till_number, :customer_cc_number

          def initialize(payload)
            super
            @customer_cc_number = payload.dig("event", "resource", "customer_cc_number")
            @till_number = payload.dig("event", "resource", "till_number")
            @settled = payload.dig("event", "resource", "settled")
          end
        end
      end
    end
  end
end
