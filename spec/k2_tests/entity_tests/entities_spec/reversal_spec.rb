# frozen_string_literal: true

RSpec.describe(K2ConnectRuby::K2Entity::Reversal) do
  describe "#initiate_reversal" do
    context "with correct reversal parameters" do
      it "sends a reversal request" do
        stub_access_token_request
        stub_reversal_request

        reversal_params = {
          transaction_reference: "Q9W28ZX1D0",
          reason: "Erroneous payment",
          metadata: {
            zendesk_ticket: "#123456",
          },
          callback_url: "https://example.com/callback",
        }
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2_reversal = described_class.new(access_token)
        k2_reversal.initiate_reversal(reversal_params)

        expect(WebMock).to(have_requested(:post, K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("reversals")))
      end

      it "returns a location url" do
        stub_access_token_request
        stub_reversal_request

        reversal_params = {
          transaction_reference: "Q9W28ZX1D0",
          reason: "Erroneous payment",
          metadata: {
            zendesk_ticket: "#123456",
          },
          callback_url: "https://example.com/callback",
        }
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2_reversal = described_class.new(access_token)
        location_url = k2_reversal.initiate_reversal(reversal_params)

        expect(location_url).to(eq("https://sandbox.kopokopo.com/api/v2/reversals/f6d21ac6-0403-4979-9657-6cfd534f74d9"))
      end
    end

    context "with no metadata" do
      it "sends a reversal request" do
        stub_access_token_request
        stub_reversal_request

        reversal_params = {
          transaction_reference: "Q9W28ZX1D0",
          reason: "Erroneous payment",
          callback_url: "https://example.com/callback",
        }
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2_reversal = described_class.new(access_token)
        k2_reversal.initiate_reversal(reversal_params)

        expect(WebMock).to(have_requested(:post, K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("reversals")))
      end

      it "returns a location url" do
        stub_access_token_request
        stub_reversal_request

        reversal_params = {
          transaction_reference: "Q9W28ZX1D0",
          reason: "Erroneous payment",
          callback_url: "https://example.com/callback",
        }
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2_reversal = described_class.new(access_token)
        location_url = k2_reversal.initiate_reversal(reversal_params)

        expect(location_url).to(eq("https://sandbox.kopokopo.com/api/v2/reversals/f6d21ac6-0403-4979-9657-6cfd534f74d9"))
      end
    end

    context "with no transaction reference" do
      it "raises the correct error" do
        stub_access_token_request
        stub_reversal_request

        reversal_params = {
          reason: "Erroneous payment",
          metadata: {
            zendesk_ticket: "#123456",
          },
          callback_url: "https://example.com/callback",
        }
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2_reversal = described_class.new(access_token)

        expect { k2_reversal.initiate_reversal(reversal_params) }.to(raise_error(ArgumentError, "Transaction reference can't be blank"))
      end
    end

    context "with no reason" do
      it "raises the correct error" do
        stub_access_token_request
        stub_reversal_request

        reversal_params = {
          transaction_reference: "Q9W28ZX1D0",
          metadata: {
            zendesk_ticket: "#123456",
          },
          callback_url: "https://example.com/callback",
        }
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2_reversal = described_class.new(access_token)

        expect { k2_reversal.initiate_reversal(reversal_params) }.to(raise_error(ArgumentError, "Reason can't be blank"))
      end
    end

    context "with no callback_url" do
      it "raises the correct error" do
        stub_access_token_request
        stub_reversal_request

        reversal_params = {
          transaction_reference: "Q9W28ZX1D0",
          reason: "Erroneous payment",
          metadata: {
            zendesk_ticket: "#123456",
          },
        }
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2_reversal = described_class.new(access_token)

        expect { k2_reversal.initiate_reversal(reversal_params) }.to(raise_error(ArgumentError, "Callback url can't be blank"))
      end
    end
  end

  describe "#query_status" do
    it "makes a request to fetch the latest reversal request" do
      stub_access_token_request
      stub_reversal_request

      reversal_params = {
        transaction_reference: "Q9W28ZX1D0",
        reason: "Erroneous payment",
        metadata: {
          zendesk_ticket: "#123456",
        },
        callback_url: "https://example.com/callback",
      }
      access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
      k2_reversal = described_class.new(access_token)
      location_url = k2_reversal.initiate_reversal(reversal_params)
      expected_response = generate_reversal_request_response
      stub_request(:get, location_url).to_return(status: 200, body: expected_response.to_json)
      k2_reversal.query_status

      expect(WebMock).to(have_requested(:get, location_url))
    end

    it "returns the correct resource details" do
      stub_access_token_request
      stub_reversal_request

      reversal_params = {
        transaction_reference: "Q9W28ZX1D0",
        reason: "Erroneous payment",
        metadata: {
          zendesk_ticket: "#123456",
        },
        callback_url: "https://example.com/callback",
      }
      access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
      k2_reversal = described_class.new(access_token)
      location_url = k2_reversal.initiate_reversal(reversal_params)
      expected_response = generate_reversal_request_response
      stub_request(:get, location_url).to_return(status: 200, body: expected_response.to_json)
      reversal_request = k2_reversal.query_status

      expect(reversal_request).to(eq(expected_response))
    end
  end

  describe "#query_resource" do
    it "makes a request to fetch the specified reversal request" do
      stub_access_token_request
      stub_reversal_request

      reversal_params = {
        transaction_reference: "Q9W28ZX1D0",
        reason: "Erroneous payment",
        metadata: {
          zendesk_ticket: "#123456",
        },
        callback_url: "https://example.com/callback",
      }
      access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
      k2_reversal = described_class.new(access_token)
      location_url = k2_reversal.initiate_reversal(reversal_params)
      expected_response = generate_reversal_request_response
      stub_request(:get, location_url).to_return(status: 200, body: expected_response.to_json)
      k2_reversal.query_resource(location_url)

      expect(WebMock).to(have_requested(:get, location_url))
    end

    it "returns the correct resource details" do
      stub_access_token_request
      stub_reversal_request

      reversal_params = {
        transaction_reference: "Q9W28ZX1D0",
        reason: "Erroneous payment",
        metadata: {
          zendesk_ticket: "#123456",
        },
        callback_url: "https://example.com/callback",
      }
      access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
      k2_reversal = described_class.new(access_token)
      location_url = k2_reversal.initiate_reversal(reversal_params)
      expected_response = generate_reversal_request_response
      stub_request(:get, location_url).to_return(status: 200, body: expected_response.to_json)
      reversal_request = k2_reversal.query_resource(location_url)

      expect(reversal_request).to(eq(expected_response))
    end
  end

  def stub_reversal_request
    stub_request(:post, K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("reversals"))
      .to_return(status: 201, headers: { location: "https://sandbox.kopokopo.com/api/v2/reversals/f6d21ac6-0403-4979-9657-6cfd534f74d9" })
  end

  def generate_reversal_request_response
    {
      data: {
        id: "f6d21ac6-0403-4979-9657-6cfd534f74d9",
        type: "reversals",
        attributes: {
          status: "Processed",
          created_at: "2026-01-28T22:11:06.022+03:00",
          transaction_reference: "Q9W28ZX1D0",
          reason: "Testing reversal on Ruby SDK",
          reversal_bulk_payment: {
            amount: "3981.0",
            status: "Transferred",
            origination_time: "2026-01-28T22:09:54.513+03:00",
            transaction_reference: "REV9J1Q26D",
          },
          errors: nil,
          metadata: {
            zendeskTicket: "#49490484",
          },
          _links: {
            callback_url: "https://example.com/callback",
            self: "https://sandbox.kopokopo.com/api/v2/reversals/f6d21ac6-0403-4979-9657-6cfd534f74d9",
          },
        },
      },
    }
  end
end

