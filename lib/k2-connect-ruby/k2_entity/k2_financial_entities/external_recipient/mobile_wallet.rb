module K2ConnectRuby
  module K2Entity
    module K2FinancialEntities
      module PayRecipient
        class MobileWallet < RecipientRequest
          include ActiveModel::Validations

          attr_accessor :first_name, :last_name, :phone_number, :email, :network

          validates :first_name, :last_name, :email, presence: true
          validates :phone_number, presence: true, length: { maximum: 13 }
          validates :email, format: {
            with: URI::MailTo::EMAIL_REGEXP,
            message: "is invalid."
          }

          validates_with K2ConnectRuby::K2Utilities::PhoneNumberValidator
        end
      end
    end
  end
end
