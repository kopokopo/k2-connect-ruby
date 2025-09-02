# frozen_string_literal: true

module K2ConnectRuby
  module K2Entity
    module K2FinancialEntities
      module SettlementAccount
        class MerchantMpesaWallet < SettlementAccountRequest
          include ActiveModel::Validations

          attr_accessor :first_name, :last_name, :phone_number, :email, :network

          validates :first_name, :last_name, :email, presence: true
          validates :phone_number, presence: true, length: { maximum: 13 }
          validates :email, format: {
            with: URI::MailTo::EMAIL_REGEXP,
            message: "is invalid.",
          }

          validates_with K2ConnectRuby::K2Utilities::PhoneNumberValidator

          def endpoint
            K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("settlement_mobile_wallet")
          end

          def request_body
            {
              nickname: nickname,
              first_name: first_name,
              last_name: last_name,
              phone_number: phone_number,
              network: network,
            }
          end
        end
      end
    end
  end
end
