module K2ConnectRuby
  module K2Entity
    module K2FinancialEntities
      module PayRecipient
        class Paybill < RecipientRequest
          include ActiveModel::Validations

          attr_accessor :paybill_name, :paybill_number, :paybill_account_number

          validates :paybill_name, :paybill_number, :paybill_account_number, presence: true
        end
      end
    end
  end
end
