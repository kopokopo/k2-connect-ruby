# frozen_string_literal: true

require "faker"

RSpec.describe(K2ConnectRuby::K2Entity::ExternalRecipient) do
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
    stub_request(:post, K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("oauth_token"))
      .to_return(body: { access_token: "access_token" }.to_json, status: 200)
  end

  def stub_add_recipient_request
    stub_request(:post, K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("pay_recipient"))
      .to_return(status: 201, body: { data: "some_data" }.to_json, headers: { location: Faker::Internet.url })
  end
end
