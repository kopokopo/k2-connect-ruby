module K2ConnectRuby
  module K2Entity
    module K2FinancialEntities
      module PayRecipient
        class Till < RecipientRequest
          include ActiveModel::Validations

          attr_accessor :till_name, :till_number

          validates :till_name, :till_number, presence: true
        end
      end
    end
  end
end
