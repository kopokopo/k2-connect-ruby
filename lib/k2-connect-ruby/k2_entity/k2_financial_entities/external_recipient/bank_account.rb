module K2ConnectRuby
  module K2Entity
    module K2FinancialEntities
      module PayRecipient
        class BankAccount < RecipientRequest
          include ActiveModel::Validations

          attr_accessor :account_name, :account_number, :bank_branch_ref

          validates :account_name, :account_number, :bank_branch_ref, presence: true
        end
      end
    end
  end
end
