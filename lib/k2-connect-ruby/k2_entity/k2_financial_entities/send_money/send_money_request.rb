# frozen_string_literal: true

module K2ConnectRuby
  module K2Entity
    module K2FinancialEntities
      module SendMoney
        class SendMoneyRequest
          include ActiveModel::Validations

          attr_accessor :source_identifier, :destinations, :destination_requests, :callback_url, :metadata

          validates :callback_url, presence: true
          validate :validate_destination_details

          def initialize(kwargs)
            kwargs.each do |key, value|
              instance_variable_set("@#{key}", value)
            end
          end

          def endpoint
            K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("send_money")
          end

          def request_body
            {
              source_identifier: source_identifier,
              destinations: destination_requests&.map(&:destination_payload),
              currency: "KES",
              metadata: metadata,
              _links: {
                callback_url: callback_url,
              },
            }
          end

          private

          def validate_destination_details
            return if destination_requests.blank?

            invalid_destination_request = destination_requests.find { |request| !request.valid? }

            if invalid_destination_request.present?
              invalid_destination_request.errors.full_messages.each { |message| self.errors.add(:base, message) }
            end
          end
        end
      end
    end
  end
end
