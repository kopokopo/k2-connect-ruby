# frozen_string_literal: true

require "faker"

RSpec.describe(K2ConnectRuby::K2Entity::K2Stk) do
  describe "#send_stk_request" do
    context "with valid details" do
      it "sends an incoming payment request" do
        stub_access_token_request
        stub_stk_push_request
        params = {
          payment_channel: "M-PESA",
          till_number: Faker::Number.number(digits: 6),
          first_name: Faker::Name.first_name,
          middle_name: Faker::Name.middle_name,
          last_name: Faker::Name.last_name,
          phone_number: "0700000000",
          email: Faker::Internet.email,
          currency: "KES",
          amount: Faker::Number.number(digits: 4),
          metadata: {
            customer_id: 123_456_789,
            reference: 123_456,
            notes: Faker::Lorem.sentence,
          },
          callback_url: Faker::Internet.url,
        }
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2_stk = K2ConnectRuby::K2Entity::K2Stk.new(access_token)
        k2_stk.send_stk_request(params)
        expect(WebMock).to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("incoming_payments"))))
      end

      it "returns a location_url" do
        stub_access_token_request
        stub_stk_push_request
        params = {
          payment_channel: "M-PESA",
          till_number: Faker::Number.number(digits: 6),
          first_name: Faker::Name.first_name,
          middle_name: Faker::Name.middle_name,
          last_name: Faker::Name.last_name,
          phone_number: "0700000000",
          email: Faker::Internet.email,
          currency: "KES",
          amount: Faker::Number.number(digits: 4),
          metadata: {
            customer_id: 123_456_789,
            reference: 123_456,
            notes: Faker::Lorem.sentence,
          },
          callback_url: Faker::Internet.url,
        }
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2_stk = K2ConnectRuby::K2Entity::K2Stk.new(access_token)
        k2_stk.send_stk_request(params)
        expect(k2_stk.location_url).not_to(eq(nil))
      end
    end

    context "with invalid details" do
      context "No phone number" do
        it "raises an error and does not send an add mobile wallet pay recipient request" do
          stub_access_token_request
          stub_stk_push_request
          params = {
            payment_channel: "M-PESA",
            till_number: Faker::Number.number(digits: 6),
            first_name: Faker::Name.first_name,
            middle_name: Faker::Name.middle_name,
            last_name: Faker::Name.last_name,
            phone_number: nil,
            email: Faker::Internet.email,
            currency: "KES",
            amount: Faker::Number.number(digits: 4),
            metadata: {
              customer_id: 123_456_789,
              reference: 123_456,
              notes: Faker::Lorem.sentence,
            },
            callback_url: Faker::Internet.url,
          }
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2_stk = K2ConnectRuby::K2Entity::K2Stk.new(access_token)
          aggregate_failures do
            expect { k2_stk.send_stk_request(params) }.to(raise_error(ArgumentError, "Phone number can't be blank"))
            expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("incoming_payments"))))
          end
        end
      end

      context "Invalid internationalized phone_number format" do
        it "raises an error and does not send an add mobile wallet pay recipient request" do
          stub_access_token_request
          stub_stk_push_request
          params = {
            payment_channel: "M-PESA",
            till_number: Faker::Number.number(digits: 6),
            first_name: Faker::Name.first_name,
            middle_name: Faker::Name.middle_name,
            last_name: Faker::Name.last_name,
            phone_number: "+255700000000",
            email: Faker::Internet.email,
            currency: "KES",
            amount: Faker::Number.number(digits: 4),
            metadata: {
              customer_id: 123_456_789,
              reference: 123_456,
              notes: Faker::Lorem.sentence,
            },
            callback_url: Faker::Internet.url,
          }
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2_stk = K2ConnectRuby::K2Entity::K2Stk.new(access_token)
          aggregate_failures do
            expect { k2_stk.send_stk_request(params) }.to(raise_error(ArgumentError, "Phone number is invalid."))
            expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("incoming_payments"))))
          end
        end
      end

      context "Invalid nationalized phone_number format" do
        it "raises an error and does not send an add mobile wallet pay recipient request" do
          stub_access_token_request
          stub_stk_push_request
          params = {
            payment_channel: "M-PESA",
            till_number: Faker::Number.number(digits: 6),
            first_name: Faker::Name.first_name,
            middle_name: Faker::Name.middle_name,
            last_name: Faker::Name.last_name,
            phone_number: "255700000000",
            email: Faker::Internet.email,
            currency: "KES",
            amount: Faker::Number.number(digits: 4),
            metadata: {
              customer_id: 123_456_789,
              reference: 123_456,
              notes: Faker::Lorem.sentence,
            },
            callback_url: Faker::Internet.url,
          }
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2_stk = K2ConnectRuby::K2Entity::K2Stk.new(access_token)
          aggregate_failures do
            expect { k2_stk.send_stk_request(params) }.to(raise_error(ArgumentError, "Phone number is invalid."))
            expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("incoming_payments"))))
          end
        end
      end

      context "Invalid local phone_number format" do
        it "raises an error and does not send an add mobile wallet pay recipient request" do
          stub_access_token_request
          stub_stk_push_request
          params = {
            payment_channel: "M-PESA",
            till_number: Faker::Number.number(digits: 6),
            first_name: Faker::Name.first_name,
            middle_name: Faker::Name.middle_name,
            last_name: Faker::Name.last_name,
            phone_number: "0900000000",
            email: Faker::Internet.email,
            currency: "KES",
            amount: Faker::Number.number(digits: 4),
            metadata: {
              customer_id: 123_456_789,
              reference: 123_456,
              notes: Faker::Lorem.sentence,
            },
            callback_url: Faker::Internet.url,
          }
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2_stk = K2ConnectRuby::K2Entity::K2Stk.new(access_token)
          aggregate_failures do
            expect { k2_stk.send_stk_request(params) }.to(raise_error(ArgumentError, "Phone number is invalid."))
            expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("incoming_payments"))))
          end
        end
      end

      context "No till number" do
        it "raises an error and does not send an add mobile wallet pay recipient request" do
          stub_access_token_request
          stub_stk_push_request
          params = {
            payment_channel: "M-PESA",
            till_number: nil,
            first_name: Faker::Name.first_name,
            middle_name: Faker::Name.middle_name,
            last_name: Faker::Name.last_name,
            phone_number: "0700000000",
            email: Faker::Internet.email,
            currency: "KES",
            amount: Faker::Number.number(digits: 4),
            metadata: {
              customer_id: 123_456_789,
              reference: 123_456,
              notes: Faker::Lorem.sentence,
            },
            callback_url: Faker::Internet.url,
          }
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2_stk = K2ConnectRuby::K2Entity::K2Stk.new(access_token)
          aggregate_failures do
            expect { k2_stk.send_stk_request(params) }.to(raise_error(ArgumentError, "Till number can't be blank"))
            expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("incoming_payments"))))
          end
        end
      end

      context "No amount" do
        it "raises an error and does not send an add mobile wallet pay recipient request" do
          stub_access_token_request
          stub_stk_push_request
          params = {
            payment_channel: "M-PESA",
            till_number: Faker::Number.number(digits: 6),
            first_name: Faker::Name.first_name,
            middle_name: Faker::Name.middle_name,
            last_name: Faker::Name.last_name,
            phone_number: "0700000000",
            email: Faker::Internet.email,
            currency: "KES",
            amount: nil,
            metadata: {
              customer_id: 123_456_789,
              reference: 123_456,
              notes: Faker::Lorem.sentence,
            },
            callback_url: Faker::Internet.url,
          }
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2_stk = K2ConnectRuby::K2Entity::K2Stk.new(access_token)
          aggregate_failures do
            expect { k2_stk.send_stk_request(params) }.to(raise_error(ArgumentError, "Amount can't be blank"))
            expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("incoming_payments"))))
          end
        end
      end

      context "No callback url" do
        it "raises an error and does not send an add mobile wallet pay recipient request" do
          stub_access_token_request
          stub_stk_push_request
          params = {
            payment_channel: "M-PESA",
            till_number: Faker::Number.number(digits: 6),
            first_name: Faker::Name.first_name,
            middle_name: Faker::Name.middle_name,
            last_name: Faker::Name.last_name,
            phone_number: "0700000000",
            email: Faker::Internet.email,
            currency: "KES",
            amount: Faker::Number.number(digits: 4),
            metadata: {
              customer_id: 123_456_789,
              reference: 123_456,
              notes: Faker::Lorem.sentence,
            },
            callback_url: nil,
          }
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2_stk = K2ConnectRuby::K2Entity::K2Stk.new(access_token)
          aggregate_failures do
            expect { k2_stk.send_stk_request(params) }.to(raise_error(ArgumentError, "Callback url can't be blank"))
            expect(WebMock).not_to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("incoming_payments"))))
          end
        end
      end
    end
  end

  describe "#query_status" do
    it "queries a recent payment request status" do
      stub_access_token_request
      stub_stk_push_request
      params = {
        payment_channel: "M-PESA",
        till_number: Faker::Number.number(digits: 6),
        first_name: Faker::Name.first_name,
        middle_name: Faker::Name.middle_name,
        last_name: Faker::Name.last_name,
        phone_number: "0700000000",
        email: Faker::Internet.email,
        currency: "KES",
        amount: Faker::Number.number(digits: 4),
        metadata: {
          customer_id: 123_456_789,
          reference: 123_456,
          notes: Faker::Lorem.sentence,
        },
        callback_url: Faker::Internet.url,
      }
      access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
      k2_stk = K2ConnectRuby::K2Entity::K2Stk.new(access_token)
      k2_stk.send_stk_request(params)
      stub_request(:get, k2_stk.location_url).to_return(status: 200, body: { data: "some_data" }.to_json)
      aggregate_failures do
        expect { k2_stk.query_status }.not_to(raise_error)
        expect(WebMock).to(have_requested(:get, K2ConnectRuby::K2Utilities::K2UrlParse.remove_localhost(URI.parse(k2_stk.location_url))))
      end
    end

    it "returns a response body" do
      stub_access_token_request
      stub_stk_push_request
      params = {
        payment_channel: "M-PESA",
        till_number: Faker::Number.number(digits: 6),
        first_name: Faker::Name.first_name,
        middle_name: Faker::Name.middle_name,
        last_name: Faker::Name.last_name,
        phone_number: "0700000000",
        email: Faker::Internet.email,
        currency: "KES",
        amount: Faker::Number.number(digits: 4),
        metadata: {
          customer_id: 123_456_789,
          reference: 123_456,
          notes: Faker::Lorem.sentence,
        },
        callback_url: Faker::Internet.url,
      }
      access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
      k2_stk = K2ConnectRuby::K2Entity::K2Stk.new(access_token)
      k2_stk.send_stk_request(params)
      stub_request(:get, k2_stk.location_url).to_return(status: 200, body: { data: "some_data" }.to_json)
      k2_stk.query_status
      expect(k2_stk.k2_response_body).not_to(eq(nil))
    end
  end

  describe "#query_resource" do
    it "queries a specified payment request status" do
      stub_access_token_request
      stub_stk_push_request
      params = {
        payment_channel: "M-PESA",
        till_number: Faker::Number.number(digits: 6),
        first_name: Faker::Name.first_name,
        middle_name: Faker::Name.middle_name,
        last_name: Faker::Name.last_name,
        phone_number: "0700000000",
        email: Faker::Internet.email,
        currency: "KES",
        amount: Faker::Number.number(digits: 4),
        metadata: {
          customer_id: 123_456_789,
          reference: 123_456,
          notes: Faker::Lorem.sentence,
        },
        callback_url: Faker::Internet.url,
      }
      access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
      k2_stk = K2ConnectRuby::K2Entity::K2Stk.new(access_token)
      k2_stk.send_stk_request(params)
      stub_request(:get, k2_stk.location_url).to_return(status: 200, body: { data: "some_data" }.to_json)
      aggregate_failures do
        expect { k2_stk.query_resource(k2_stk.location_url) }.not_to(raise_error)
        expect(WebMock).to(have_requested(:get, K2ConnectRuby::K2Utilities::K2UrlParse.remove_localhost(URI.parse(k2_stk.location_url))))
      end
    end

    it "returns a response body" do
      stub_access_token_request
      stub_stk_push_request
      params = {
        payment_channel: "M-PESA",
        till_number: Faker::Number.number(digits: 6),
        first_name: Faker::Name.first_name,
        middle_name: Faker::Name.middle_name,
        last_name: Faker::Name.last_name,
        phone_number: "0700000000",
        email: Faker::Internet.email,
        currency: "KES",
        amount: Faker::Number.number(digits: 4),
        metadata: {
          customer_id: 123_456_789,
          reference: 123_456,
          notes: Faker::Lorem.sentence,
        },
        callback_url: Faker::Internet.url,
      }
      access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
      k2_stk = K2ConnectRuby::K2Entity::K2Stk.new(access_token)
      k2_stk.send_stk_request(params)
      stub_request(:get, k2_stk.location_url).to_return(status: 200, body: { data: "some_data" }.to_json)
      k2_stk.query_resource(k2_stk.location_url)
      expect(k2_stk.k2_response_body).not_to(eq(nil))
    end
  end

  def stub_access_token_request
    stub_request(:post, K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("oauth_token"))
      .to_return(body: { access_token: "access_token" }.to_json, status: 200)
  end

  def stub_stk_push_request
    stub_request(:post, K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("incoming_payments"))
      .to_return(status: 201, body: { data: "some_data" }.to_json, headers: { location: Faker::Internet.url })
  end
end
