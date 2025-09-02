# frozen_string_literal: true

require "faker"

RSpec.describe(K2ConnectRuby::K2Entity::ExternalRecipient) do
  describe "#add_external_recipient" do
    context "Adding a Mobile PAY Recipient" do
      context "Correct recipient details" do
        it "should send an add mobile wallet pay recipient request" do
          stub_access_token_request
          stub_add_recipient_request
          params = {
            type: "mobile_wallet",
            first_name: Faker::Name.first_name,
            last_name: Faker::Name.last_name,
            email: Faker::Internet.email,
            phone_number: "+254700000000",
          }
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2pay = K2ConnectRuby::K2Entity::ExternalRecipient.new(access_token)
          k2pay.add_external_recipient(params)
          expect(WebMock).to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("pay_recipient"))))
        end

        it "returns a location_url" do
          stub_access_token_request
          stub_add_recipient_request
          params = {
            type: "mobile_wallet",
            first_name: Faker::Name.first_name,
            last_name: Faker::Name.last_name,
            email: Faker::Internet.email,
            phone_number: "+254700000000",
          }
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2pay = K2ConnectRuby::K2Entity::ExternalRecipient.new(access_token)
          k2pay.add_external_recipient(params)
          expect(k2pay.recipients_location_url).not_to(eq(nil))
        end
      end

      context "Wrong recipient details" do
        context "No first_name" do
          it "raises an error and does not send an add mobile wallet pay recipient request" do
            stub_access_token_request
            stub_add_recipient_request
            params = {
              type: "mobile_wallet",
              first_name: nil,
              last_name: Faker::Name.last_name,
              email: Faker::Internet.email,
              phone_number: "+254700000000",
            }
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2pay = K2ConnectRuby::K2Entity::ExternalRecipient.new(access_token)
            aggregate_failures do
              expect { k2pay.add_external_recipient(params) }.to(raise_error(ArgumentError, "First name can't be blank"))
              expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("pay_recipient"))))
            end
          end
        end

        context "No last_name" do
          it "raises an error and does not send an add mobile wallet pay recipient request" do
            stub_access_token_request
            stub_add_recipient_request
            params = {
              type: "mobile_wallet",
              first_name: Faker::Name.first_name,
              last_name: nil,
              email: Faker::Internet.email,
              phone_number: "+254700000000",
            }
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2pay = K2ConnectRuby::K2Entity::ExternalRecipient.new(access_token)
            aggregate_failures do
              expect { k2pay.add_external_recipient(params) }.to(raise_error(ArgumentError, "Last name can't be blank"))
              expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("pay_recipient"))))
            end
          end
        end

        context "No phone_number" do
          it "raises an error and does not send an add mobile wallet pay recipient request" do
            stub_access_token_request
            stub_add_recipient_request
            params = {
              type: "mobile_wallet",
              first_name: Faker::Name.first_name,
              last_name: Faker::Name.last_name,
              email: Faker::Internet.email,
              phone_number: nil,
            }
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2pay = K2ConnectRuby::K2Entity::ExternalRecipient.new(access_token)
            aggregate_failures do
              expect { k2pay.add_external_recipient(params) }.to(raise_error(ArgumentError, "Phone number can't be blank"))
              expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("pay_recipient"))))
            end
          end
        end

        context "Invalid internationalized phone_number format" do
          it "raises an error and does not send an add mobile wallet pay recipient request" do
            stub_access_token_request
            stub_add_recipient_request
            params = {
              type: "mobile_wallet",
              first_name: Faker::Name.first_name,
              last_name: Faker::Name.last_name,
              email: Faker::Internet.email,
              phone_number: "+255700000000",
            }
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2pay = K2ConnectRuby::K2Entity::ExternalRecipient.new(access_token)

            aggregate_failures do
              expect { k2pay.add_external_recipient(params) }.to(raise_error(ArgumentError, "Phone number is invalid."))
              expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("pay_recipient"))))
            end
          end
        end

        context "Invalid nationalized phone_number format" do
          it "raises an error and does not send an add mobile wallet pay recipient request" do
            stub_access_token_request
            stub_add_recipient_request
            params = {
              type: "mobile_wallet",
              first_name: Faker::Name.first_name,
              last_name: Faker::Name.last_name,
              email: Faker::Internet.email,
              phone_number: "255700000000",
            }
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2pay = K2ConnectRuby::K2Entity::ExternalRecipient.new(access_token)
            aggregate_failures do
              expect { k2pay.add_external_recipient(params) }.to(raise_error(ArgumentError, "Phone number is invalid."))
              expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("pay_recipient"))))
            end
          end
        end

        context "Invalid local phone_number format" do
          it "raises an error and does not send an add mobile wallet pay recipient request" do
            stub_access_token_request
            stub_add_recipient_request
            params = {
              type: "mobile_wallet",
              first_name: Faker::Name.first_name,
              last_name: Faker::Name.last_name,
              email: Faker::Internet.email,
              phone_number: "0900000000",
            }
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2pay = K2ConnectRuby::K2Entity::ExternalRecipient.new(access_token)
            aggregate_failures do
              expect { k2pay.add_external_recipient(params) }.to(raise_error(ArgumentError, "Phone number is invalid."))
              expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("pay_recipient"))))
            end
          end
        end

        context "No email" do
          it "raises an error and does not send an add mobile wallet pay recipient request" do
            stub_access_token_request
            stub_add_recipient_request
            params = {
              type: "mobile_wallet",
              first_name: Faker::Name.first_name,
              last_name: Faker::Name.last_name,
              email: nil,
              phone_number: "+254700000000",
            }
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2pay = K2ConnectRuby::K2Entity::ExternalRecipient.new(access_token)
            aggregate_failures do
              expect { k2pay.add_external_recipient(params) }.to(raise_error(ArgumentError, "Email can't be blank"))
              expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("pay_recipient"))))
            end
          end
        end

        context "Invalid email format" do
          it "raises an error and does not send an add mobile wallet pay recipient request" do
            stub_access_token_request
            stub_add_recipient_request
            params = {
              type: "mobile_wallet",
              first_name: Faker::Name.first_name,
              last_name: Faker::Name.last_name,
              email: "test",
              phone_number: "+254700000000",
            }
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2pay = K2ConnectRuby::K2Entity::ExternalRecipient.new(access_token)
            aggregate_failures do
              expect { k2pay.add_external_recipient(params) }.to(raise_error(ArgumentError, "Email is invalid."))
              expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("pay_recipient"))))
            end
          end
        end
      end
    end

    context "Adding a Bank PAY Recipient" do
      context "Correct recipient details" do
        it "should send an add bank account pay recipient request" do
          stub_access_token_request
          stub_add_recipient_request
          params = {
            type: "bank_account",
            account_name: Faker::Name.name_with_middle,
            account_number: Faker::Number.number(digits: 10),
            bank_branch_ref: Faker::Internet.uuid,
            nickname: Faker::Name.name_with_middle,
          }
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2pay = K2ConnectRuby::K2Entity::ExternalRecipient.new(access_token)
          k2pay.add_external_recipient(params)
          expect(WebMock).to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("pay_recipient"))))
        end

        it "returns a location_url" do
          stub_access_token_request
          stub_add_recipient_request
          params = {
            type: "bank_account",
            account_name: Faker::Name.name_with_middle,
            account_number: Faker::Number.number(digits: 10),
            bank_branch_ref: Faker::Internet.uuid,
            nickname: Faker::Name.name_with_middle,
          }
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2pay = K2ConnectRuby::K2Entity::ExternalRecipient.new(access_token)
          k2pay.add_external_recipient(params)
          expect(k2pay.recipients_location_url).not_to(eq(nil))
        end
      end

      context "Wrong recipient details" do
        context "No account_name" do
          it "raises an error and does not send an add mobile wallet pay recipient request" do
            stub_access_token_request
            stub_add_recipient_request
            params = {
              type: "bank_account",
              account_name: nil,
              account_number: Faker::Number.number(digits: 10),
              bank_branch_ref: Faker::Internet.uuid,
              settlement_method: "EFT",
            }
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2pay = K2ConnectRuby::K2Entity::ExternalRecipient.new(access_token)
            aggregate_failures do
              expect { k2pay.add_external_recipient(params) }.to(raise_error(ArgumentError, "Account name can't be blank"))
              expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("pay_recipient"))))
            end
          end
        end

        context "No account_number" do
          it "raises an error and does not send an add mobile wallet pay recipient request" do
            stub_access_token_request
            stub_add_recipient_request
            params = {
              type: "bank_account",
              account_name: Faker::Name.name_with_middle,
              account_number: nil,
              bank_branch_ref: Faker::Internet.uuid,
              settlement_method: "EFT",
            }
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2pay = K2ConnectRuby::K2Entity::ExternalRecipient.new(access_token)
            aggregate_failures do
              expect { k2pay.add_external_recipient(params) }.to(raise_error(ArgumentError, "Account number can't be blank"))
              expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("pay_recipient"))))
            end
          end
        end

        context "No bank_branch_ref" do
          it "raises an error and does not send an add mobile wallet pay recipient request" do
            stub_access_token_request
            stub_add_recipient_request
            params = {
              type: "bank_account",
              account_name: Faker::Name.name_with_middle,
              account_number: Faker::Number.number(digits: 10),
              bank_branch_ref: nil,
              settlement_method: "EFT",
            }
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2pay = K2ConnectRuby::K2Entity::ExternalRecipient.new(access_token)
            aggregate_failures do
              expect { k2pay.add_external_recipient(params) }.to(raise_error(ArgumentError, "Bank branch ref can't be blank"))
              expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("pay_recipient"))))
            end
          end
        end
      end
    end

    context "Adding a Till PAY Recipient" do
      context "Correct recipient details" do
        it "should send an add till pay recipient request" do
          stub_access_token_request
          stub_add_recipient_request
          params = {
            type: "till",
            till_name: Faker::Company.name,
            till_number: Faker::Number.number(digits: 6),
            nickname: Faker::Name.name_with_middle,
          }
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2pay = K2ConnectRuby::K2Entity::ExternalRecipient.new(access_token)
          k2pay.add_external_recipient(params)
          expect(WebMock).to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("pay_recipient"))))
        end

        it "returns a location_url" do
          stub_access_token_request
          stub_add_recipient_request
          params = {
            type: "till",
            till_name: Faker::Company.name,
            till_number: Faker::Number.number(digits: 6),
            nickname: Faker::Name.name_with_middle,
          }
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2pay = K2ConnectRuby::K2Entity::ExternalRecipient.new(access_token)
          k2pay.add_external_recipient(params)
          expect(k2pay.recipients_location_url).not_to(eq(nil))
        end
      end

      context "Wrong recipient details" do
        context "No till_name" do
          it "raises an error and does not send an add mobile wallet pay recipient request" do
            stub_access_token_request
            stub_add_recipient_request
            params = {
              type: "till",
              till_name: nil,
              till_number: Faker::Number.number(digits: 6),
              nickname: Faker::Name.name_with_middle,
            }
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2pay = K2ConnectRuby::K2Entity::ExternalRecipient.new(access_token)
            aggregate_failures do
              expect { k2pay.add_external_recipient(params) }.to(raise_error(ArgumentError, "Till name can't be blank"))
              expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("pay_recipient"))))
            end
          end
        end

        context "No till_number" do
          it "raises an error and does not send an add mobile wallet pay recipient request" do
            stub_access_token_request
            stub_add_recipient_request
            params = {
              type: "till",
              till_name: Faker::Company.name,
              till_number: nil,
              nickname: Faker::Name.name_with_middle,
            }
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2pay = K2ConnectRuby::K2Entity::ExternalRecipient.new(access_token)
            aggregate_failures do
              expect { k2pay.add_external_recipient(params) }.to(raise_error(ArgumentError, "Till number can't be blank"))
              expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("pay_recipient"))))
            end
          end
        end
      end
    end

    context "Adding a Paybill PAY Recipient" do
      context "Correct recipient details" do
        it "should send an add paybill pay recipient request" do
          stub_access_token_request
          stub_add_recipient_request
          params = {
            type: "paybill",
            paybill_name: Faker::Company.name,
            paybill_number: Faker::Number.number(digits: 6),
            paybill_account_number: Faker::Number.number(digits: 6),
            nickname: Faker::Name.name_with_middle,
          }
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2pay = K2ConnectRuby::K2Entity::ExternalRecipient.new(access_token)
          k2pay.add_external_recipient(params)
          expect(WebMock).to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("pay_recipient"))))
        end

        it "returns a location_url" do
          stub_access_token_request
          stub_add_recipient_request
          params = {
            type: "paybill",
            paybill_name: Faker::Company.name,
            paybill_number: Faker::Number.number(digits: 6),
            paybill_account_number: Faker::Number.number(digits: 6),
            nickname: Faker::Name.name_with_middle,
          }
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2pay = K2ConnectRuby::K2Entity::ExternalRecipient.new(access_token)
          k2pay.add_external_recipient(params)
          expect(k2pay.recipients_location_url).not_to(eq(nil))
        end
      end

      context "Wrong recipient details" do
        context "No paybill_name" do
          it "raises an error and does not send an add mobile wallet pay recipient request" do
            stub_access_token_request
            stub_add_recipient_request
            params = {
              type: "paybill",
              paybill_name: nil,
              paybill_number: Faker::Number.number(digits: 6),
              paybill_account_number: Faker::Number.number(digits: 6),
              nickname: Faker::Name.name_with_middle,
            }
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2pay = K2ConnectRuby::K2Entity::ExternalRecipient.new(access_token)
            aggregate_failures do
              expect { k2pay.add_external_recipient(params) }.to(raise_error(ArgumentError, "Paybill name can't be blank"))
              expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("pay_recipient"))))
            end
          end
        end

        context "No paybill_number" do
          it "raises an error and does not send an add mobile wallet pay recipient request" do
            stub_access_token_request
            stub_add_recipient_request
            params = {
              type: "paybill",
              paybill_name: Faker::Company.name,
              paybill_number: nil,
              paybill_account_number: Faker::Number.number(digits: 6),
              nickname: Faker::Name.name_with_middle,
            }
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2pay = K2ConnectRuby::K2Entity::ExternalRecipient.new(access_token)
            aggregate_failures do
              expect { k2pay.add_external_recipient(params) }.to(raise_error(ArgumentError, "Paybill number can't be blank"))
              expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("pay_recipient"))))
            end
          end
        end

        context "No paybill_account_number" do
          it "raises an error and does not send an add mobile wallet pay recipient request" do
            stub_access_token_request
            stub_add_recipient_request
            params = {
              type: "paybill",
              paybill_name: Faker::Company.name,
              paybill_number: Faker::Number.number(digits: 6),
              paybill_account_number: nil,
              nickname: Faker::Name.name_with_middle,
            }
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2pay = K2ConnectRuby::K2Entity::ExternalRecipient.new(access_token)
            aggregate_failures do
              expect { k2pay.add_external_recipient(params) }.to(raise_error(ArgumentError, "Paybill account number can't be blank"))
              expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("pay_recipient"))))
            end
          end
        end
      end
    end

    context "No type provided" do
      it "raises an error and does not send an add mobile wallet pay recipient request" do
        stub_access_token_request
        stub_add_recipient_request
        params = {
          type: "pay bill",
          paybill_name: nil,
          paybill_number: Faker::Number.number(digits: 6),
          paybill_account_number: Faker::Number.number(digits: 6),
          nickname: Faker::Name.name_with_middle,
        }
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2pay = K2ConnectRuby::K2Entity::ExternalRecipient.new(access_token)
        aggregate_failures do
          expect { k2pay.add_external_recipient(params) }.to(raise_error(ArgumentError, "Undefined payment method."))
          expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("pay_recipient"))))
        end
      end
    end
  end

  describe "#query_status" do
    context "for adding pay recipients" do
      it "queries recently added pay recipient" do
        stub_access_token_request
        stub_add_recipient_request
        params = {
          type: "mobile_wallet",
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          email: Faker::Internet.email,
          phone_number: "+254700000000",
        }
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2pay = K2ConnectRuby::K2Entity::ExternalRecipient.new(access_token)
        k2pay.add_external_recipient(params)
        stub_request(:get, k2pay.recipients_location_url).to_return(status: 200, body: { data: "some_data" }.to_json)
        aggregate_failures do
          expect { k2pay.query_status }.not_to(raise_error)
          expect(WebMock).to(have_requested(:get, K2ConnectRuby::K2Utilities::K2UrlParse.remove_localhost(URI.parse(k2pay.recipients_location_url))))
        end
      end

      it "returns a response body" do
        stub_access_token_request
        stub_add_recipient_request
        params = {
          type: "mobile_wallet",
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          email: Faker::Internet.email,
          phone_number: "+254700000000",
        }
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2pay = K2ConnectRuby::K2Entity::ExternalRecipient.new(access_token)
        k2pay.add_external_recipient(params)
        stub_request(:get, k2pay.recipients_location_url).to_return(status: 200, body: { data: "some_data" }.to_json)
        k2pay.query_status
        expect(k2pay.k2_response_body).not_to(eq(nil))
      end
    end
  end

  describe "#query_resource" do
    context "for adding pay recipients" do
      it "should query adding pay recipients" do
        stub_access_token_request
        stub_add_recipient_request
        params = {
          type: "mobile_wallet",
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          email: Faker::Internet.email,
          phone_number: "+254700000000",
        }
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2pay = K2ConnectRuby::K2Entity::ExternalRecipient.new(access_token)
        k2pay.add_external_recipient(params)
        stub_request(:get, k2pay.recipients_location_url).to_return(status: 200, body: { data: "some_data" }.to_json)
        aggregate_failures do
          expect { k2pay.query_resource(k2pay.recipients_location_url) }.not_to(raise_error)
          expect(WebMock).to(have_requested(:get, K2ConnectRuby::K2Utilities::K2UrlParse.remove_localhost(URI.parse(k2pay.recipients_location_url))))
        end
      end

      it "returns a response body" do
        stub_access_token_request
        stub_add_recipient_request
        params = {
          type: "mobile_wallet",
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          email: Faker::Internet.email,
          phone_number: "+254700000000",
        }
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2pay = K2ConnectRuby::K2Entity::ExternalRecipient.new(access_token)
        k2pay.add_external_recipient(params)
        stub_request(:get, k2pay.recipients_location_url).to_return(status: 200, body: { data: "some_data" }.to_json)
        k2pay.query_resource(k2pay.recipients_location_url)
        expect(k2pay.k2_response_body).not_to(eq(nil))
      end
    end
  end

  def stub_access_token_request
    stub_request(:post, "https://sandbox.kopokopo.com/oauth/token")
      .to_return(body: { access_token: "access_token" }.to_json, status: 200)
  end

  def stub_add_recipient_request
    stub_request(:post, "https://sandbox.kopokopo.com/api/v1/pay_recipients")
      .to_return(status: 201, body: { data: "some_data" }.to_json, headers: { location: Faker::Internet.url })
  end
end
