# frozen_string_literal: true

module K2ConnectRuby
  module K2Entity
    module K2FinancialEntities
      module TransferAccount
        class MerchantBankAccount < TransferAccountRequest
          include ActiveModel::Validations

          attr_accessor :account_name, :account_number, :bank_branch_ref, :settlement_method

          validates :account_name, :account_number, :bank_branch_ref, :settlement_method, presence: true
          validates :settlement_method, inclusion: {
            in: ["EFT", "RTS"],
            message: "is invalid.",
          }

          def endpoint
            K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("settlement_bank_account")
          end

          def request_body
            {
              nickname: nickname,
              account_name: account_name,
              account_number: account_number,
              bank_branch_ref: bank_branch_ref,
              settlement_method: settlement_method,
            }
          end
        end
      end
    end
  end
end
