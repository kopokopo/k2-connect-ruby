# frozen_string_literal: true

require "faker"

RSpec.describe(K2ConnectRuby::K2Entity::K2Subscribe) do
  describe "#initialize" do
    it "should initialize with access_token" do
      K2ConnectRuby::K2Entity::K2Subscribe.new("access_token")
    end

    it "should raise an error when there is an empty access_token" do
      expect { K2ConnectRuby::K2Entity::K2Subscribe.new("") }.to(raise_error(ArgumentError))
    end
  end

  describe "#webhook_subscribe" do
    let(:empty_event) { webhook_structure("", "till", 112233) }
    let(:wrong_event) { webhook_structure("event_type", "till", 112233) }

    # Correct webhooks
    let(:b2b) { webhook_structure("b2b_transaction_received", "till", 112233) }
    let(:bg) { webhook_structure("buygoods_transaction_received", "till", 112233) }
    let(:customer_created) { webhook_structure("customer_created", "company") }
    let(:settlement) { webhook_structure("settlement_transfer_completed", "company") }
    let(:bg_reversed) { webhook_structure("buygoods_transaction_reversed", "till", 112233) }
    # Incorrect Webhooks
    let(:incorrect_b2b) { webhook_structure("b2b_transaction_received", "company", 112233) }
    let(:incorrect_b2b) { webhook_structure("buygoods_transaction_received", "company", 112233) }
    let(:incorrect_customer_created) { webhook_structure("customer_created", "till", 112233) }
    let(:incorrect_settlement) { webhook_structure("settlement_transfer_completed", "till", 112233) }
    let(:incorrect_bg_reversed) { webhook_structure("buygoods_transaction_reversed", "company", 112233) }

    context "with invalid details" do
      context "event type does not exist" do
        it "raises error if event type does not match" do
          stub_access_token_request
          stub_webhook_subscribe
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2_subscribe = K2ConnectRuby::K2Entity::K2Subscribe.new(access_token)
          expect { k2_subscribe.webhook_subscribe(wrong_event) }.to(raise_error(ArgumentError, "Event type is invalid"))
        end
      end

      context "url is empty" do
        it "raises error if event type is empty" do
          stub_access_token_request
          stub_webhook_subscribe
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2_subscribe = K2ConnectRuby::K2Entity::K2Subscribe.new(access_token)
          empty_url = {
            event_type: "buygoods_transaction_received",
            url: nil,
            scope: "till",
            scope_reference: 112233,
          }
          expect { k2_subscribe.webhook_subscribe(empty_url) }.to(raise_error(ArgumentError, "Url can't be blank"))
        end
      end

      context "event type is empty" do
        it "raises error if event type is empty" do
          stub_access_token_request
          stub_webhook_subscribe
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2_subscribe = K2ConnectRuby::K2Entity::K2Subscribe.new(access_token)
          expect { k2_subscribe.webhook_subscribe(empty_event) }.to(raise_error(ArgumentError, "Event type can't be blank"))
        end
      end

      context "scope is empty" do
        it "raises error if event type is empty" do
          stub_access_token_request
          stub_webhook_subscribe
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2_subscribe = K2ConnectRuby::K2Entity::K2Subscribe.new(access_token)
          empty_scope = {
            event_type: "buygoods_transaction_received",
            url: Faker::Internet.url,
            scope: nil,
            scope_reference: 112233,
          }
          expect { k2_subscribe.webhook_subscribe(empty_scope) }.to(raise_error(ArgumentError, "Scope can't be blank"))
        end
      end

      context "invalid scope" do
        it "raises error if event type is empty" do
          stub_access_token_request
          stub_webhook_subscribe
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2_subscribe = K2ConnectRuby::K2Entity::K2Subscribe.new(access_token)
          invalid_scope = {
            event_type: "buygoods_transaction_received",
            url: Faker::Internet.url,
            scope: "scope",
            scope_reference: 112233,
          }
          expect { k2_subscribe.webhook_subscribe(invalid_scope) }.to(raise_error(ArgumentError, "Scope must be one of 'till' or 'company'."))
        end
      end

      context "scope reference is empty for till" do
        it "raises error if event type is empty" do
          stub_access_token_request
          stub_webhook_subscribe
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2_subscribe = K2ConnectRuby::K2Entity::K2Subscribe.new(access_token)
          empty_scope_reference = {
            event_type: "buygoods_transaction_received",
            url: Faker::Internet.url,
            scope: "till",
            scope_reference: nil,
          }
          expect { k2_subscribe.webhook_subscribe(empty_scope_reference) }.to(raise_error(ArgumentError, "Scope reference can't be blank"))
        end
      end
    end

    context "valid event type" do
      context "with buy goods received event type" do
        it "should send a webhook subscription" do
          stub_access_token_request
          stub_webhook_subscribe
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2_subscribe = K2ConnectRuby::K2Entity::K2Subscribe.new(access_token)

          aggregate_failures do
            expect { k2_subscribe.webhook_subscribe(bg) }.not_to(raise_error)
            expect(WebMock).to(have_requested(:post, K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("webhook_subscriptions")))
          end
        end
      end

      context "with buy goods reversed event type" do
        it "should send a webhook subscription" do
          stub_access_token_request
          stub_webhook_subscribe
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2_subscribe = K2ConnectRuby::K2Entity::K2Subscribe.new(access_token)

          aggregate_failures do
            expect { k2_subscribe.webhook_subscribe(bg_reversed) }.not_to(raise_error)
            expect(WebMock).to(have_requested(:post, K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("webhook_subscriptions")))
          end
        end
      end

      context "with customer created event type" do
        it "should send a webhook subscription" do
          stub_access_token_request
          stub_webhook_subscribe
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2_subscribe = K2ConnectRuby::K2Entity::K2Subscribe.new(access_token)

          aggregate_failures do
            expect { k2_subscribe.webhook_subscribe(customer_created) }.not_to(raise_error)
            expect(WebMock).to(have_requested(:post, K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("webhook_subscriptions")))
          end
        end
      end

      context "with external till to till (b2b) event type" do
        it "should send a webhook subscription" do
          stub_access_token_request
          stub_webhook_subscribe
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2_subscribe = K2ConnectRuby::K2Entity::K2Subscribe.new(access_token)

          aggregate_failures do
            expect { k2_subscribe.webhook_subscribe(b2b) }.not_to(raise_error)
            expect(WebMock).to(have_requested(:post, K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("webhook_subscriptions")))
          end
        end
      end

      context "with settlement transfer event type" do
        it "should send a webhook subscription for settlement" do
          stub_access_token_request
          stub_webhook_subscribe
          access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
          k2_subscribe = K2ConnectRuby::K2Entity::K2Subscribe.new(access_token)

          aggregate_failures do
            expect { k2_subscribe.webhook_subscribe(settlement) }.not_to(raise_error)
            expect(WebMock).to(have_requested(:post, K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("webhook_subscriptions")))
          end
        end
      end
    end
  end

  describe "#query_webhook" do
    it "should query recent webhook subscription" do
      stub_access_token_request
      stub_webhook_subscribe
      access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
      k2_subscribe = K2ConnectRuby::K2Entity::K2Subscribe.new(access_token)
      bg = webhook_structure("buygoods_transaction_received", "till", 112233)
      k2_subscribe.webhook_subscribe(bg)
      stub_request(:get, k2_subscribe.location_url).to_return(status: 200, body: { data: "some_data" }.to_json)

      aggregate_failures do
        expect { k2_subscribe.query_webhook }.not_to(raise_error)
        expect(WebMock).to(have_requested(:get, K2ConnectRuby::K2Utilities::K2UrlParse.remove_localhost(URI.parse(k2_subscribe.location_url))))
      end
    end

    it "returns a response body" do
      stub_access_token_request
      stub_webhook_subscribe
      access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
      k2_subscribe = K2ConnectRuby::K2Entity::K2Subscribe.new(access_token)
      bg = webhook_structure("buygoods_transaction_received", "till", 112233)
      k2_subscribe.webhook_subscribe(bg)
      stub_request(:get, k2_subscribe.location_url).to_return(status: 200, body: { data: "some_data" }.to_json)
      k2_subscribe.query_webhook
      expect(k2_subscribe.k2_response_body).not_to(eq(nil))
    end
  end

  describe "#query_resource_url" do
    it "should query recent webhook subscription" do
      stub_access_token_request
      stub_webhook_subscribe
      access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
      k2_subscribe = K2ConnectRuby::K2Entity::K2Subscribe.new(access_token)
      bg = webhook_structure("buygoods_transaction_received", "till", 112233)
      k2_subscribe.webhook_subscribe(bg)
      stub_request(:get, k2_subscribe.location_url).to_return(status: 200, body: { data: "some_data" }.to_json)
      aggregate_failures do
        expect { k2_subscribe.query_resource_url(k2_subscribe.location_url) }.not_to(raise_error)
        expect(WebMock).to(have_requested(:get, K2ConnectRuby::K2Utilities::K2UrlParse.remove_localhost(URI.parse(k2_subscribe.location_url))))
      end
    end

    it "returns a response body" do
      stub_access_token_request
      stub_webhook_subscribe
      access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
      k2_subscribe = K2ConnectRuby::K2Entity::K2Subscribe.new(access_token)
      bg = webhook_structure("buygoods_transaction_received", "till", 112233)
      k2_subscribe.webhook_subscribe(bg)
      stub_request(:get, k2_subscribe.location_url).to_return(status: 200, body: { data: "some_data" }.to_json)
      k2_subscribe.query_resource_url(k2_subscribe.location_url)
      expect(k2_subscribe.k2_response_body).not_to(eq(nil))
    end
  end

  def webhook_structure(event_type, scope, scope_reference = nil)
    {
      event_type: event_type,
      url: Faker::Internet.url,
      scope: scope,
      scope_reference: scope_reference,
    }
  end

  def stub_access_token_request
    stub_request(:post, K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("oauth_token"))
      .to_return(body: { access_token: "access_token" }.to_json, status: 200)
  end

  def stub_webhook_subscribe
    stub_request(:post, K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("webhook_subscriptions"))
      .to_return(status: 201, body: { data: "some_data" }.to_json, headers: { location: Faker::Internet.url })
  end
end
