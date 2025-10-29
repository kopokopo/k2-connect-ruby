# frozen_string_literal: true

# Class for collecting destination details for external bank accounts

module K2ConnectRuby
  module K2Entity
    module K2FinancialEntities
      module Destination
        class ExternalBankAccount < DestinationRequest
          include ActiveModel::Validations

          attr_accessor :account_name, :account_number, :bank_branch_ref

          validates :account_name, :account_number, :bank_branch_ref, :description, presence: true

          def destination_payload
            {
              type: type,
              nickname: nickname,
              account_name: account_name,
              account_number: account_number,
              bank_branch_ref: bank_branch_ref,
              amount: amount,
              description: description,
              favourite: favourite,
            }
          end
        end
      end
    end
  end
end
