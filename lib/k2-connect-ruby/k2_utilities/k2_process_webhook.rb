# frozen_string_literal: true

module K2ConnectRuby
  module K2Utilities
    module K2ProcessWebhook
      extend self

      def process(payload, secret_key, signature)
        raise ArgumentError, "Empty/Nil Request Body Argument!" if payload.blank?

        process_webhook(payload) if K2ConnectRuby::K2Utilities::K2Authenticator.authenticate(payload, secret_key, signature)
      end

      def process_webhook(payload)
        if daraja_payload?(payload)
          K2ConnectRuby::K2Services::Payloads::DarajaWebhooks.new(payload)
        else
          process_k2_connect_payload(payload)
        end
      end

      def process_k2_connect_payload(payload)
        result_topic = payload.dig("topic")
        case result_topic
          # Buygoods Transaction Received
        when "buygoods_transaction_received"
          K2ConnectRuby::K2Services::Payloads::Webhooks::BuygoodsTransactionReceived.new(payload)
          # Buygoods Transaction Reversed
        when "buygoods_transaction_reversed"
          K2ConnectRuby::K2Services::Payloads::Webhooks::BuygoodsTransactionReversed.new(payload)
          # B2B Transaction
        when "b2b_transaction_received"
          K2ConnectRuby::K2Services::Payloads::Webhooks::B2bTransactionReceived.new(payload)
          # B2B Transaction Reversed
        when "b2b_transaction_reversed"
          K2ConnectRuby::K2Services::Payloads::Webhooks::B2bTransactionReversed.new(payload)
          # Settlement Transfer
        when "settlement_transfer_completed"
          K2ConnectRuby::K2Services::Payloads::Webhooks::TransferWebhook.new(payload)
          # Customer Created
        when "customer_created"
          K2ConnectRuby::K2Services::Payloads::Webhooks::CustomerCreated.new(payload)
        else
          raise ArgumentError, "No Other Specified Event!"
        end
      end

      def daraja_payload?(payload)
        payload.key?("TransactionType")
      end

      # Returns a Hash Object
      def return_obj_hash(instance_hash = HashWithIndifferentAccess.new, obj)
        obj.instance_variables.each do |value|
          instance_hash[:"#{value.to_s.tr('@', '')}"] = obj.instance_variable_get(value)
        end
        instance_hash.each(&:freeze).freeze
      end

      # Returns an Array Object
      def return_obj_array(instance_array = [], obj)
        obj.instance_variables.each do |value|
          instance_array << obj.instance_variable_get(value)
        end
        instance_array.each(&:freeze).freeze
      end
    end
  end
end
