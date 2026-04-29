module K2ConnectRuby
  module K2Services
    module Payloads
      module Webhooks
        class BuygoodsTransactionReversed < Buygoods
          include ActiveModel::Validations

          validates :topic, comparison: { equal_to: "buygoods_transaction_reversed" }

          def initialize(payload)
            super
          end
        end
      end
    end
  end
end
