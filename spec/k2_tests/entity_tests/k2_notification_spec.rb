# frozen_string_literal: true

require "faker"

RSpec.describe(K2ConnectRuby::K2Entity::K2Notification) do

  describe "#initialize" do
    it "should initialize with access_token" do
      K2ConnectRuby::K2Entity::K2Notification.new("access_token")
    end

    it "should raise an error when there is an empty access_token" do
      expect { K2ConnectRuby::K2Entity::K2Notification.new("") }.to(raise_error(ArgumentError))
    end
  end

  describe "#send_sms_transaction_notification" do
    it "should send an sms transaction notification request" do
      stub_access_token_request
      stub_sms_transaction_notification
      access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
      k2_notification = K2ConnectRuby::K2Entity::K2Notification.new(access_token)
      sms_notification_payload = HashWithIndifferentAccess.new(webhook_event_reference: "webhook_event_reference", message: "message", callback_url: "callback_url")

      aggregate_failures do
        expect { k2_notification.send_sms_transaction_notification(sms_notification_payload) }.not_to(raise_error)
        expect(WebMock).to(have_requested(:post, K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("transaction_sms_notifications")))
      end
    end

    it "returns a location_url" do
      stub_access_token_request
      stub_sms_transaction_notification
      access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
      k2_notification = K2ConnectRuby::K2Entity::K2Notification.new(access_token)
      sms_notification_payload = HashWithIndifferentAccess.new(webhook_event_reference: "webhook_event_reference", message: "message", callback_url: "callback_url")
      k2_notification.send_sms_transaction_notification(sms_notification_payload)
      expect(k2_notification.location_url).not_to(eq(nil))
    end

    context "with invalid details" do
      context "no webhook_event_reference" do
        it "raises an error and does not send a request" do
          stub_access_token_request
          stub_sms_transaction_notification
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2_notification = K2ConnectRuby::K2Entity::K2Notification.new(access_token)
          sms_notification_payload = HashWithIndifferentAccess.new(webhook_event_reference: nil, message: "message", callback_url: "callback_url")

          aggregate_failures do
            expect { k2_notification.send_sms_transaction_notification(sms_notification_payload) }.to(raise_error(ArgumentError, "Webhook event reference can't be blank"))
            expect(WebMock).to_not(have_requested(:post, K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("transaction_sms_notifications")))
          end
        end
      end

      context "no message" do
        it "raises an error and does not send a request" do
          stub_access_token_request
          stub_sms_transaction_notification
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2_notification = K2ConnectRuby::K2Entity::K2Notification.new(access_token)
          sms_notification_payload = HashWithIndifferentAccess.new(webhook_event_reference: "webhook_event_reference", message: nil, callback_url: "callback_url")

          aggregate_failures do
            expect { k2_notification.send_sms_transaction_notification(sms_notification_payload) }.to(raise_error(ArgumentError, "Message can't be blank"))
            expect(WebMock).to_not(have_requested(:post, K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("transaction_sms_notifications")))
          end
        end
      end

      context "no callback_url" do
        it "raises an error and does not send a request" do
          stub_access_token_request
          stub_sms_transaction_notification
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2_notification = K2ConnectRuby::K2Entity::K2Notification.new(access_token)
          sms_notification_payload = HashWithIndifferentAccess.new(webhook_event_reference: "webhook_event_reference", message: "message", callback_url: nil)

          aggregate_failures do
            expect { k2_notification.send_sms_transaction_notification(sms_notification_payload) }.to(raise_error(ArgumentError, "Callback url can't be blank"))
            expect(WebMock).to_not(have_requested(:post, K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("transaction_sms_notifications")))
          end
        end
      end
    end
  end

  describe "#query_resource" do
    it "should query recent sms transaction notification request" do
      stub_access_token_request
      stub_sms_transaction_notification
      access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
      k2_notification = K2ConnectRuby::K2Entity::K2Notification.new(access_token)
      sms_notification_payload = HashWithIndifferentAccess.new(webhook_event_reference: "webhook_event_reference", message: "message", callback_url: "callback_url")
      k2_notification.send_sms_transaction_notification(sms_notification_payload)
      stub_request(:get, k2_notification.location_url).to_return(status: 200, body: { data: "some_data" }.to_json)
      aggregate_failures do
        expect { k2_notification.query_resource }.not_to(raise_error)
        expect(WebMock).to(have_requested(:get, K2ConnectRuby::K2Utilities::K2UrlParse.remove_localhost(URI.parse(k2_notification.location_url))))
      end
    end

    it "returns a response body" do
      stub_access_token_request
      stub_sms_transaction_notification
      access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
      k2_notification = K2ConnectRuby::K2Entity::K2Notification.new(access_token)
      sms_notification_payload = HashWithIndifferentAccess.new(webhook_event_reference: "webhook_event_reference", message: "message", callback_url: "callback_url")
      k2_notification.send_sms_transaction_notification(sms_notification_payload)
      stub_request(:get, k2_notification.location_url).to_return(status: 200, body: { data: "some_data" }.to_json)
      k2_notification.query_resource
      expect(k2_notification.k2_response_body).not_to(eq(nil))
    end
  end

  describe "#query_resource_url" do
    it "should query specific resource_url" do
      stub_access_token_request
      stub_sms_transaction_notification
      access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
      k2_notification = K2ConnectRuby::K2Entity::K2Notification.new(access_token)
      sms_notification_payload = HashWithIndifferentAccess.new(webhook_event_reference: "webhook_event_reference", message: "message", callback_url: "callback_url")
      k2_notification.send_sms_transaction_notification(sms_notification_payload)
      stub_request(:get, k2_notification.location_url).to_return(status: 200, body: { data: "some_data" }.to_json)

      aggregate_failures do
        expect { k2_notification.query_resource_url(k2_notification.location_url) }.not_to(raise_error)
        expect(WebMock).to(have_requested(:get, K2ConnectRuby::K2Utilities::K2UrlParse.remove_localhost(URI.parse(k2_notification.location_url))))
      end
    end

    it "returns a response body" do
      stub_access_token_request
      stub_sms_transaction_notification
      access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
      k2_notification = K2ConnectRuby::K2Entity::K2Notification.new(access_token)
      sms_notification_payload = HashWithIndifferentAccess.new(webhook_event_reference: "webhook_event_reference", message: "message", callback_url: "callback_url")
      k2_notification.send_sms_transaction_notification(sms_notification_payload)
      stub_request(:get, k2_notification.location_url).to_return(status: 200, body: { data: "some_data" }.to_json)
      k2_notification.query_resource_url(k2_notification.location_url)
      expect(k2_notification.k2_response_body).not_to(eq(nil))
    end
  end

  def stub_access_token_request
    stub_request(:post, "https://sandbox.kopokopo.com/oauth/token")
      .to_return(body: { access_token: "access_token" }.to_json, status: 200)
  end

  def stub_sms_transaction_notification
    stub_request(:post, "https://sandbox.kopokopo.com/api/v1/transaction_sms_notifications")
      .to_return(status: 201, body: { data: "some_data" }.to_json, headers: { location: Faker::Internet.url })
  end
end
