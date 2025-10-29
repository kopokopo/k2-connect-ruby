# frozen_string_literal: true

require "faker"

RSpec.describe(K2ConnectRuby::K2Entity::SendMoney) do
  describe "#create_payment" do
    context "send money to external_mobile_wallet" do
      context "Correct send money details" do
        it "should send a send money request" do
          stub_access_token_request
          stub_send_money_request
          params = {
            destinations: [
              {
                type: "mobile_wallet",
                network: "Safaricom",
                phone_number: "254700000000",
                nickname: Faker::Name.name,
                amount: Faker::Number.number(digits: 4),
                description: "pay via K2 Connect",
              },
            ],
            currency: "KES",
            source_identifier: nil,
            callback_url: Faker::Internet.url,
          }
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2pay = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
          k2pay.create_payment(params)
          expect(WebMock).to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("send_money"))))
        end

        it "returns a location_url" do
          stub_access_token_request
          stub_send_money_request
          params = {
            destinations: [
              {
                type: "mobile_wallet",
                network: "Safaricom",
                phone_number: "254700000000",
                nickname: Faker::Name.name,
                amount: Faker::Number.number(digits: 4),
                description: "pay via K2 Connect",
              },
            ],
            currency: "KES",
            source_identifier: nil,
            callback_url: Faker::Internet.url,
          }
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2pay = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
          k2pay.create_payment(params)
          expect(k2pay.payments_location_url).not_to(eq(nil))
        end
      end

      context "Invalid send money details" do
        context "no phone number provided" do
          it "raises an error and does not send a send money request" do
            stub_access_token_request
            stub_send_money_request
            params = {
              destinations: [
                {
                  type: "mobile_wallet",
                  network: "Safaricom",
                  phone_number: nil,
                  nickname: Faker::Name.name,
                  amount: Faker::Number.number(digits: 4),
                  description: "pay via K2 Connect",
                },
              ],
              currency: "KES",
              source_identifier: nil,
              callback_url: Faker::Internet.url,
            }
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2pay = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
            aggregate_failures do
              expect { k2pay.create_payment(params) }.to(raise_error(ArgumentError, "Phone number can't be blank"))
              expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("payments"))))
            end
          end
        end

        context "Invalid internationalized phone_number format" do
          it "raises an error and does not send a send money request" do
            stub_access_token_request
            stub_send_money_request
            params = {
              destinations: [
                {
                  type: "mobile_wallet",
                  network: "Safaricom",
                  phone_number: "+255916230902",
                  nickname: Faker::Name.name,
                  amount: Faker::Number.number(digits: 4),
                  description: "pay via K2 Connect",
                },
              ],
              currency: "KES",
              source_identifier: nil,
              callback_url: Faker::Internet.url,
            }
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2pay = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
            aggregate_failures do
              expect { k2pay.create_payment(params) }.to(raise_error(ArgumentError, "Phone number is invalid."))
              expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("payments"))))
            end
          end
        end

        context "Invalid nationalized phone_number format" do
          it "raises an error and does not send a send money request" do
            stub_access_token_request
            stub_send_money_request
            params = {
              destinations: [
                {
                  type: "mobile_wallet",
                  network: "Safaricom",
                  phone_number: "255716230902",
                  nickname: Faker::Name.name,
                  amount: Faker::Number.number(digits: 4),
                  description: "pay via K2 Connect",
                },
              ],
              currency: "KES",
              source_identifier: nil,
              callback_url: Faker::Internet.url,
            }
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2pay = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
            aggregate_failures do
              expect { k2pay.create_payment(params) }.to(raise_error(ArgumentError, "Phone number is invalid."))
              expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("payments"))))
            end
          end
        end

        context "Invalid local phone_number format" do
          it "raises an error and does not send a send money request" do
            stub_access_token_request
            stub_send_money_request
            params = {
              destinations: [
                {
                  type: "mobile_wallet",
                  network: "Safaricom",
                  phone_number: "0916230902",
                  nickname: Faker::Name.name,
                  amount: Faker::Number.number(digits: 4),
                  description: "pay via K2 Connect",
                },
              ],
              currency: "KES",
              source_identifier: nil,
              callback_url: Faker::Internet.url,
            }
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2pay = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
            aggregate_failures do
              expect { k2pay.create_payment(params) }.to(raise_error(ArgumentError, "Phone number is invalid."))
              expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("payments"))))
            end
          end
        end

        context "no callback url provided" do
          it "raises an error and does not send a send money request" do
            stub_access_token_request
            stub_send_money_request
            params = {
              destinations: [
                {
                  type: "mobile_wallet",
                  network: "Safaricom",
                  phone_number: "0700000000",
                  nickname: Faker::Name.name,
                  amount: Faker::Number.number(digits: 4),
                  description: "pay via K2 Connect",
                },
              ],
              currency: "KES",
              source_identifier: nil,
              callback_url: nil,
            }
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2pay = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
            aggregate_failures do
              expect { k2pay.create_payment(params) }.to(raise_error(ArgumentError, "Callback url can't be blank"))
              expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("payments"))))
            end
          end
        end
      end
    end

    context "send money to external_bank_account" do
      context "Correct send money details" do
        it "should send a send money request" do
          stub_access_token_request
          stub_send_money_request
          params = {
            destinations: [
              {
                type: "bank_account",
                bank_branch_ref: Faker::Internet.uuid,
                account_name: Faker::Name.name,
                account_number: Faker::Number.number(digits: 6),
                nickname: Faker::Name.name,
                amount: Faker::Number.number(digits: 4),
                currency: "KES",
                description: "pay via K2 Connect",
              },
            ],
            currency: "KES",
            source_identifier: nil,
            callback_url: Faker::Internet.url,
          }
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2pay = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
          k2pay.create_payment(params)
          expect(WebMock).to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("send_money"))))
        end

        it "returns a location_url" do
          stub_access_token_request
          stub_send_money_request
          params = {
            destinations: [
              {
                type: "bank_account",
                bank_branch_ref: Faker::Internet.uuid,
                account_name: Faker::Name.name,
                account_number: Faker::Number.number(digits: 6),
                nickname: Faker::Name.name,
                amount: Faker::Number.number(digits: 4),
                currency: "KES",
                description: "pay via K2 Connect",
              },
            ],
            currency: "KES",
            source_identifier: nil,
            callback_url: Faker::Internet.url,
          }
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2pay = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
          k2pay.create_payment(params)
          expect(k2pay.payments_location_url).not_to(eq(nil))
        end
      end

      context "Invalid send money details" do
        context "no account name provided" do
          it "raises an error and does not send a send money request" do
            stub_access_token_request
            stub_send_money_request
            params = {
              destinations: [
                {
                  type: "bank_account",
                  bank_branch_ref: Faker::Internet.uuid,
                  account_name: nil,
                  account_number: Faker::Number.number(digits: 6),
                  nickname: Faker::Name.name,
                  amount: Faker::Number.number(digits: 4),
                  description: "pay via K2 Connect",
                },
              ],
              currency: "KES",
              source_identifier: nil,
              callback_url: Faker::Internet.url,
            }
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2pay = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
            aggregate_failures do
              expect { k2pay.create_payment(params) }.to(raise_error(ArgumentError, "Account name can't be blank"))
              expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("payments"))))
            end
          end
        end

        context "no account number provided" do
          it "raises an error and does not send a send money request" do
            stub_access_token_request
            stub_send_money_request
            params = {
              destinations: [
                {
                  type: "bank_account",
                  bank_branch_ref: Faker::Internet.uuid,
                  account_name: Faker::Name.name,
                  account_number: nil,
                  nickname: Faker::Name.name,
                  amount: Faker::Number.number(digits: 4),
                  description: "pay via K2 Connect",
                },
              ],
              currency: "KES",
              source_identifier: nil,
              callback_url: Faker::Internet.url,
            }
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2pay = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
            aggregate_failures do
              expect { k2pay.create_payment(params) }.to(raise_error(ArgumentError, "Account number can't be blank"))
              expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("payments"))))
            end
          end
        end

        context "no bank_branch_ref provided" do
          it "raises an error and does not send a send money request" do
            stub_access_token_request
            stub_send_money_request
            params = {
              destinations: [
                {
                  type: "bank_account",
                  bank_branch_ref: nil,
                  account_name: Faker::Name.name,
                  account_number: Faker::Number.number(digits: 6),
                  nickname: Faker::Name.name,
                  amount: Faker::Number.number(digits: 4),
                  description: "pay via K2 Connect",
                },
              ],
              currency: "KES",
              source_identifier: nil,
              callback_url: Faker::Internet.url,
            }
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2pay = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
            aggregate_failures do
              expect { k2pay.create_payment(params) }.to(raise_error(ArgumentError, "Bank branch ref can't be blank"))
              expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("payments"))))
            end
          end
        end

        context "no callback url provided" do
          it "raises an error and does not send a send money request" do
            stub_access_token_request
            stub_send_money_request
            params = {
              destinations: [
                {
                  type: "bank_account",
                  bank_branch_ref: Faker::Internet.uuid,
                  account_name: Faker::Name.name,
                  account_number: Faker::Number.number(digits: 6),
                  nickname: Faker::Name.name,
                  amount: Faker::Number.number(digits: 4),
                  description: "pay via K2 Connect",
                },
              ],
              currency: "KES",
              source_identifier: nil,
              callback_url: nil,
            }
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2pay = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
            aggregate_failures do
              expect { k2pay.create_payment(params) }.to(raise_error(ArgumentError, "Callback url can't be blank"))
              expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("payments"))))
            end
          end
        end
      end
    end

    context "send money to external_till" do
      context "Correct send money details" do
        it "should send a send money request" do
          stub_access_token_request
          stub_send_money_request
          params = {
            destinations: [
              {
                type: "till",
                till_number: Faker::Number.number(digits: 6),
                nickname: Faker::Name.name,
                amount: Faker::Number.number(digits: 4),
                currency: "KES",
                description: "pay via K2 Connect",
              },
            ],
            currency: "KES",
            source_identifier: nil,
            callback_url: Faker::Internet.url,
          }
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2pay = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
          k2pay.create_payment(params)
          expect(WebMock).to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("send_money"))))
        end

        it "returns a location_url" do
          stub_access_token_request
          stub_send_money_request
          params = {
            destinations: [
              {
                type: "till",
                till_number: Faker::Number.number(digits: 6),
                nickname: Faker::Name.name,
                amount: Faker::Number.number(digits: 4),
                currency: "KES",
                description: "pay via K2 Connect",
              },
            ],
            currency: "KES",
            source_identifier: nil,
            callback_url: Faker::Internet.url,
          }
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2pay = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
          k2pay.create_payment(params)
          expect(k2pay.payments_location_url).not_to(eq(nil))
        end
      end

      context "Invalid send money details" do
        context "no till number provided" do
          it "raises an error and does not send a send money request" do
            stub_access_token_request
            stub_send_money_request
            params = {
              destinations: [
                {
                  type: "till",
                  till_number: nil,
                  nickname: Faker::Name.name,
                  amount: Faker::Number.number(digits: 4),
                  description: "pay via K2 Connect",
                },
              ],
              currency: "KES",
              source_identifier: nil,
              callback_url: Faker::Internet.url,
            }
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2pay = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
            aggregate_failures do
              expect { k2pay.create_payment(params) }.to(raise_error(ArgumentError, "Till number can't be blank"))
              expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("payments"))))
            end
          end
        end

        context "no callback url provided" do
          it "raises an error and does not send a send money request" do
            stub_access_token_request
            stub_send_money_request
            params = {
              destinations: [
                {
                  type: "till",
                  till_number: Faker::Number.number(digits: 6),
                  nickname: Faker::Name.name,
                  amount: Faker::Number.number(digits: 4),
                  description: "pay via K2 Connect",
                },
              ],
              currency: "KES",
              source_identifier: nil,
              callback_url: nil,
            }
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2pay = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
            aggregate_failures do
              expect { k2pay.create_payment(params) }.to(raise_error(ArgumentError, "Callback url can't be blank"))
              expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("payments"))))
            end
          end
        end
      end
    end

    context "send money to external_paybill" do
      context "Correct send money details" do
        it "should send a send money request" do
          stub_access_token_request
          stub_send_money_request
          params = {
            destinations: [
              {
                type: "paybill",
                paybill_number: Faker::Number.number(digits: 6),
                paybill_account_number: Faker::Number.number(digits: 10),
                nickname: Faker::Name.name,
                amount: Faker::Number.number(digits: 4),
                currency: "KES",
                description: "pay via K2 Connect",
              },
            ],
            currency: "KES",
            source_identifier: nil,
            callback_url: Faker::Internet.url,
          }
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2pay = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
          k2pay.create_payment(params)
          expect(WebMock).to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("send_money"))))
        end

        it "returns a location_url" do
          stub_access_token_request
          stub_send_money_request
          params = {
            destinations: [
              {
                type: "paybill",
                paybill_number: Faker::Number.number(digits: 6),
                paybill_account_number: Faker::Number.number(digits: 10),
                nickname: Faker::Name.name,
                amount: Faker::Number.number(digits: 4),
                currency: "KES",
                description: "pay via K2 Connect",
              },
            ],
            currency: "KES",
            source_identifier: nil,
            callback_url: Faker::Internet.url,
          }
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2pay = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
          k2pay.create_payment(params)
          expect(k2pay.payments_location_url).not_to(eq(nil))
        end
      end

      context "Invalid send money details" do
        context "no paybill number provided" do
          it "raises an error and does not send a send money request" do
            stub_access_token_request
            stub_send_money_request
            params = {
              destinations: [
                {
                  type: "paybill",
                  paybill_number: nil,
                  paybill_account_number: Faker::Number.number(digits: 10),
                  nickname: Faker::Name.name,
                  amount: Faker::Number.number(digits: 4),
                  description: "pay via K2 Connect",
                },
              ],
              currency: "KES",
              source_identifier: nil,
              callback_url: Faker::Internet.url,
            }
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2pay = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
            aggregate_failures do
              expect { k2pay.create_payment(params) }.to(raise_error(ArgumentError, "Paybill number can't be blank"))
              expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("payments"))))
            end
          end
        end

        context "no paybill account number provided" do
          it "raises an error and does not send a send money request" do
            stub_access_token_request
            stub_send_money_request
            params = {
              destinations: [
                {
                  type: "paybill",
                  paybill_number: Faker::Number.number(digits: 6),
                  paybill_account_number: nil,
                  nickname: Faker::Name.name,
                  amount: Faker::Number.number(digits: 4),
                  description: "pay via K2 Connect",
                },
              ],
              currency: "KES",
              source_identifier: nil,
              callback_url: Faker::Internet.url,
            }
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2pay = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
            aggregate_failures do
              expect { k2pay.create_payment(params) }.to(raise_error(ArgumentError, "Paybill account number can't be blank"))
              expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("payments"))))
            end
          end
        end

        context "no callback url provided" do
          it "raises an error and does not send a send money request" do
            stub_access_token_request
            stub_send_money_request
            params = {
              destinations: [
                {
                  type: "paybill",
                  paybill_number: Faker::Number.number(digits: 6),
                  paybill_account_number: Faker::Number.number(digits: 10),
                  nickname: Faker::Name.name,
                  amount: Faker::Number.number(digits: 4),
                  description: "pay via K2 Connect",
                },
              ],
              currency: "KES",
              source_identifier: nil,
              callback_url: nil,
            }
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2pay = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
            aggregate_failures do
              expect { k2pay.create_payment(params) }.to(raise_error(ArgumentError, "Callback url can't be blank"))
              expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("payments"))))
            end
          end
        end
      end
    end

    context "send money to my bank account" do
      context "Correct send money details" do
        it "should send a send money request" do
          stub_access_token_request
          stub_send_money_request
          params = {
            destinations: [
              {
                type: "merchant_bank_account",
                reference: Faker::Internet.url,
                amount: Faker::Number.number(digits: 4),
                currency: "KES",
              },
            ],
            currency: "KES",
            source_identifier: nil,
            callback_url: Faker::Internet.url,
          }
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2pay = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
          k2pay.create_payment(params)
          expect(WebMock).to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("send_money"))))
        end

        it "returns a location_url" do
          stub_access_token_request
          stub_send_money_request
          params = {
            destinations: [
              {
                type: "merchant_bank_account",
                reference: Faker::Internet.url,
                amount: Faker::Number.number(digits: 4),
                currency: "KES",
              },
            ],
            currency: "KES",
            source_identifier: nil,
            callback_url: Faker::Internet.url,
          }
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2pay = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
          k2pay.create_payment(params)
          expect(k2pay.payments_location_url).not_to(eq(nil))
        end
      end

      context "Invalid send money details" do
        context "no reference provided" do
          it "raises an error and does not send a send money request" do
            stub_access_token_request
            stub_send_money_request
            params = {
              destinations: [
                {
                  type: "merchant_bank_account",
                  reference: nil,
                  amount: Faker::Number.number(digits: 4),
                },
              ],
              currency: "KES",
              source_identifier: nil,
              callback_url: Faker::Internet.url,
            }
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2pay = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
            aggregate_failures do
              expect { k2pay.create_payment(params) }.to(raise_error(ArgumentError, "Reference can't be blank"))
              expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("payments"))))
            end
          end
        end

        context "no callback url provided" do
          it "raises an error and does not send a send money request" do
            stub_access_token_request
            stub_send_money_request
            params = {
              destinations: [
                {
                  type: "merchant_bank_account",
                  reference: Faker::Internet.url,
                  amount: Faker::Number.number(digits: 4),
                },
              ],
              currency: "KES",
              source_identifier: nil,
              callback_url: nil,
            }
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2pay = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
            aggregate_failures do
              expect { k2pay.create_payment(params) }.to(raise_error(ArgumentError, "Callback url can't be blank"))
              expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("payments"))))
            end
          end
        end
      end
    end

    context "send money to my M-PESA wallet" do
      context "Correct send money details" do
        it "should send a send money request" do
          stub_access_token_request
          stub_send_money_request
          params = {
            destinations: [
              {
                type: "merchant_wallet",
                reference: Faker::Internet.url,
                amount: Faker::Number.number(digits: 4),
                currency: "KES",
              },
            ],
            currency: "KES",
            source_identifier: nil,
            callback_url: Faker::Internet.url,
          }
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2pay = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
          k2pay.create_payment(params)
          expect(WebMock).to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("send_money"))))
        end

        it "returns a location_url" do
          stub_access_token_request
          stub_send_money_request
          params = {
            destinations: [
              {
                type: "merchant_wallet",
                reference: Faker::Internet.url,
                amount: Faker::Number.number(digits: 4),
                currency: "KES",
              },
            ],
            currency: "KES",
            source_identifier: nil,
            callback_url: Faker::Internet.url,
          }
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2pay = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
          k2pay.create_payment(params)
          expect(k2pay.payments_location_url).not_to(eq(nil))
        end
      end

      context "Invalid send money details" do
        context "no reference provided" do
          it "raises an error and does not send a send money request" do
            stub_access_token_request
            stub_send_money_request
            params = {
              destinations: [
                {
                  type: "merchant_wallet",
                  reference: nil,
                  amount: Faker::Number.number(digits: 4),
                },
              ],
              currency: "KES",
              source_identifier: nil,
              callback_url: Faker::Internet.url,
            }
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2pay = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
            aggregate_failures do
              expect { k2pay.create_payment(params) }.to(raise_error(ArgumentError, "Reference can't be blank"))
              expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("payments"))))
            end
          end
        end

        context "no callback url provided" do
          it "raises an error and does not send a send money request" do
            stub_access_token_request
            stub_send_money_request
            params = {
              destinations: [
                {
                  type: "merchant_wallet",
                  reference: Faker::Internet.url,
                  amount: Faker::Number.number(digits: 4),
                },
              ],
              currency: "KES",
              source_identifier: nil,
              callback_url: nil,
            }
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2pay = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
            aggregate_failures do
              expect { k2pay.create_payment(params) }.to(raise_error(ArgumentError, "Callback url can't be blank"))
              expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("payments"))))
            end
          end
        end
      end
    end

    context "send money to my accounts" do
      context "Correct send money details" do
        it "should send a send money request" do
          stub_access_token_request
          stub_send_money_request
          params = {
            destinations: [],
            currency: "KES",
            source_identifier: nil,
            callback_url: Faker::Internet.url,
          }
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2pay = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
          k2pay.create_payment(params)
          expect(WebMock).to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("send_money"))))
        end

        it "returns a location_url" do
          stub_access_token_request
          stub_send_money_request
          params = {
            destinations: [],
            currency: "KES",
            source_identifier: nil,
            callback_url: Faker::Internet.url,
          }
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2pay = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
          k2pay.create_payment(params)
          expect(k2pay.payments_location_url).not_to(eq(nil))
        end
      end

      context "Invalid send money details" do
        context "when no callback url is provided" do
          it "raises an error and does not send a send money request" do
            stub_access_token_request
            stub_send_money_request
            params = {
              destinations: [],
              currency: "KES",
              source_identifier: nil,
              callback_url: nil,
            }
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2pay = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
            aggregate_failures do
              expect { k2pay.create_payment(params) }.to(raise_error(ArgumentError, "Callback url can't be blank"))
              expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("payments"))))
            end
          end
        end
      end
    end

    context "when invalid destination type is provided" do
      it "raises an error and does not send a send money request" do
        stub_access_token_request
        stub_send_money_request
        params = {
          destinations: [
            {
              type: "test",
              network: "Safaricom",
              phone_number: "254700000000",
              nickname: Faker::Name.name,
              amount: Faker::Number.number(digits: 4),
              currency: "KES",
              description: "pay via K2 Connect",
            },
          ],
          currency: "KES",
          source_identifier: nil,
          callback_url: Faker::Internet.url,
        }
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2pay = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
        aggregate_failures do
          expect { k2pay.create_payment(params) }.to(raise_error(ArgumentError, "Undefined destination type."))
          expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("payments"))))
        end
      end
    end

    context "no currency provided" do
      it "raises an error and does not send a send money request" do
        stub_access_token_request
        stub_send_money_request
        params = {
          destinations: [
            {
              type: "mobile_wallet",
              network: "Safaricom",
              phone_number: "0700000000",
              nickname: Faker::Name.name,
              amount: Faker::Number.number(digits: 4),
              description: "pay via K2 Connect",
            },
          ],
          source_identifier: nil,
          callback_url: Faker::Internet.url,
        }
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2pay = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
        aggregate_failures do
          expect { k2pay.create_payment(params) }.to(raise_error(ArgumentError, "Currency can't be blank"))
          expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("payments"))))
        end
      end
    end

    context "invalid currency provided" do
      it "raises an error and does not send a send money request" do
        stub_access_token_request
        stub_send_money_request
        params = {
          destinations: [
            {
              type: "mobile_wallet",
              network: "Safaricom",
              phone_number: "0700000000",
              nickname: Faker::Name.name,
              amount: Faker::Number.number(digits: 4),
              description: "pay via K2 Connect",
            },
          ],
          currency: "USD",
          source_identifier: nil,
          callback_url: Faker::Internet.url,
        }
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2pay = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
        aggregate_failures do
          expect { k2pay.create_payment(params) }.to(raise_error(ArgumentError, "Currency must be 'KES'."))
          expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("payments"))))
        end
      end
    end
  end

  describe "#query_status" do
    context "for creating payments" do
      it "should query creating payment request status" do
        stub_access_token_request
        stub_send_money_request
        params = {
          destinations: [
            {
              type: "mobile_wallet",
              network: "Safaricom",
              phone_number: "254700000000",
              nickname: Faker::Name.name,
              amount: Faker::Number.number(digits: 4),
              description: "pay via K2 Connect",
            },
          ],
          currency: "KES",
          source_identifier: nil,
          callback_url: Faker::Internet.url,
        }
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2pay = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
        k2pay.create_payment(params)
        stub_request(:get, k2pay.payments_location_url).to_return(status: 200, body: { data: "some_data" }.to_json)
        aggregate_failures do
          expect { k2pay.query_status }.not_to(raise_error)
          expect(WebMock).to(have_requested(:get, K2ConnectRuby::K2Utilities::K2UrlParse.remove_localhost(URI.parse(k2pay.payments_location_url))))
        end
      end

      it "returns a response body" do
        stub_access_token_request
        stub_send_money_request
        params = {
          destinations: [
            {
              type: "mobile_wallet",
              network: "Safaricom",
              phone_number: "254700000000",
              nickname: Faker::Name.name,
              amount: Faker::Number.number(digits: 4),
              currency: "KES",
              description: "pay via K2 Connect",
            },
          ],
          currency: "KES",
          source_identifier: nil,
          callback_url: Faker::Internet.url,
        }
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2pay = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
        k2pay.create_payment(params)
        stub_request(:get, k2pay.payments_location_url).to_return(status: 200, body: { data: "some_data" }.to_json)
        k2pay.query_status
        expect(k2pay.k2_response_body).not_to(eq(nil))
      end
    end
  end

  describe "#query_resource" do
    context "for creating payments" do
      it "should query creating payment request status" do
        stub_access_token_request
        stub_send_money_request
        params = {
          destinations: [
            {
              type: "mobile_wallet",
              network: "Safaricom",
              phone_number: "254700000000",
              nickname: Faker::Name.name,
              amount: Faker::Number.number(digits: 4),
              currency: "KES",
              description: "pay via K2 Connect",
            },
          ],
          currency: "KES",
          source_identifier: nil,
          callback_url: Faker::Internet.url,
        }
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2pay = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
        k2pay.create_payment(params)
        stub_request(:get, k2pay.payments_location_url).to_return(status: 200, body: { data: "some_data" }.to_json)
        aggregate_failures do
          expect { k2pay.query_resource(k2pay.payments_location_url) }.not_to(raise_error)
          expect(WebMock).to(have_requested(:get, K2ConnectRuby::K2Utilities::K2UrlParse.remove_localhost(URI.parse(k2pay.payments_location_url))))
        end
      end

      it "returns a response body" do
        stub_access_token_request
        stub_send_money_request
        params = {
          destinations: [
            {
              type: "mobile_wallet",
              network: "Safaricom",
              phone_number: "254700000000",
              nickname: Faker::Name.name,
              amount: Faker::Number.number(digits: 4),
              currency: "KES",
              description: "pay via K2 Connect",
            },
          ],
          currency: "KES",
          source_identifier: nil,
          callback_url: Faker::Internet.url,
        }
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2pay = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
        k2pay.create_payment(params)
        stub_request(:get, k2pay.payments_location_url).to_return(status: 200, body: { data: "some_data" }.to_json)
        k2pay.query_resource(k2pay.payments_location_url)
        expect(k2pay.k2_response_body).not_to(eq(nil))
      end
    end
  end

  def stub_access_token_request
    stub_request(:post, K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("oauth_token"))
      .to_return(body: { access_token: "access_token" }.to_json, status: 200)
  end

  def stub_send_money_request
    stub_request(:post, "https://sandbox.kopokopo.com/api/v2/send_money")
      .to_return(status: 201, body: { data: "some_data" }.to_json, headers: { location: Faker::Internet.url })
  end
end
