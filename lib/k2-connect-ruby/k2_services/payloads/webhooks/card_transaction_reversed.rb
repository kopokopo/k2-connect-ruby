module K2ConnectRuby
  module K2Services
    module Payloads
      module Webhooks
        class CardTransactionReversed < K2CommonEvents
          attr_reader :till_number, :customer_cc_number

          def initialize(payload)
            super
            @customer_cc_number = payload.dig("event", "resource", "customer_cc_number")
            @till_number = payload.dig("event", "resource", "till_number")
          end
        end
      end
    end
  end
end
