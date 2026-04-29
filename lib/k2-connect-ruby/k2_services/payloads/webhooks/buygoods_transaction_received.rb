# frozen_string_literal: true

module K2ConnectRuby
  module K2Services
    module Payloads
      module Webhooks
        class BuygoodsTransactionReceived < Buygoods
          include ActiveModel::Validations

          validates :topic, comparison: { equal_to: "buygoods_transaction_received" }

          def initialize(payload)
            super
          end
        end
      end
    end
  end
end
