# frozen_string_literal: true

module K2ConnectRuby
  module K2Utilities
    class PhoneNumberValidator < ActiveModel::Validator
      def validate(record)
        phone_number = record.phone_number

        record.errors.add(:phone_number, "is invalid.") if phone_number&.size == 13 && !phone_number&.starts_with?("+2547")
        record.errors.add(:phone_number, "is invalid.") if phone_number&.size == 12 && !phone_number&.starts_with?("2547")
        record.errors.add(:phone_number, "is invalid.") if phone_number&.size == 10 && !phone_number&.starts_with?("07")
      end
    end
  end
end
