# frozen_string_literal: true

RSpec.describe(K2ConnectRuby::K2Entity::PaymentLink) do
  describe "#create_payment_link" do
    context "with correct payment link arguments" do
      it "sends a request to create a payment link" do
        stub_access_token_request
        stub_payment_link_request

        payment_link_params = {
          till_number: "4321",
          currency: "KES",
          amount: 1000,
          payment_reference: "INV02932922",
          note: "Payment for monthly internet subscription",
          metadata: {
            account_number: "1234567",
          },
          callback_url: "https://example.com/callback",
        }
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2_payment_links = described_class.new(access_token)
        k2_payment_links.create_payment_link(payment_link_params)

        expect(WebMock).to(have_requested(:post, K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("payment_links")))
      end

      it "returns the created payment link's resource url" do
        stub_access_token_request
        stub_payment_link_request

        payment_link_params = {
          till_number: "4321",
          currency: "KES",
          amount: 1000,
          payment_reference: "INV02932922",
          note: "Payment for monthly internet subscription",
          metadata: {
            account_number: "1234567",
          },
          callback_url: "https://example.com/callback",
        }
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2_payment_links = described_class.new(access_token)
        location_url = k2_payment_links.create_payment_link(payment_link_params)

        expect(location_url).to(eq("https://sandbox.kopokopo.com/api/v2/payment_links/f387e4d7-6a32-4f2d-ba1e-809eab2d9614"))
      end
    end

    context "without payment reference" do
      it "sends a request to create a payment link" do
        stub_access_token_request
        stub_payment_link_request

        payment_link_params = {
          till_number: "4321",
          currency: "KES",
          amount: 1000,
          note: "Payment for monthly internet subscription",
          metadata: {
            account_number: "1234567",
          },
          callback_url: "https://example.com/callback",
        }
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2_payment_links = described_class.new(access_token)
        k2_payment_links.create_payment_link(payment_link_params)

        expect(WebMock).to(have_requested(:post, K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("payment_links")))
      end

      it "returns the created payment link's resource url" do
        stub_access_token_request
        stub_payment_link_request

        payment_link_params = {
          till_number: "4321",
          currency: "KES",
          amount: 1000,
          note: "Payment for monthly internet subscription",
          metadata: {
            account_number: "1234567",
          },
          callback_url: "https://example.com/callback",
        }
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2_payment_links = described_class.new(access_token)
        location_url = k2_payment_links.create_payment_link(payment_link_params)

        expect(location_url).to(eq("https://sandbox.kopokopo.com/api/v2/payment_links/f387e4d7-6a32-4f2d-ba1e-809eab2d9614"))
      end
    end

    context "without note" do
      it "sends a request to create a payment link" do
        stub_access_token_request
        stub_payment_link_request

        payment_link_params = {
          till_number: "4321",
          currency: "KES",
          amount: 1000,
          payment_reference: "INV02932922",
          metadata: {
            account_number: "1234567",
          },
          callback_url: "https://example.com/callback",
        }
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2_payment_links = described_class.new(access_token)
        k2_payment_links.create_payment_link(payment_link_params)

        expect(WebMock).to(have_requested(:post, K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("payment_links")))
      end

      it "returns the created payment link's resource url" do
        stub_access_token_request
        stub_payment_link_request

        payment_link_params = {
          till_number: "4321",
          currency: "KES",
          amount: 1000,
          payment_reference: "INV02932922",
          metadata: {
            account_number: "1234567",
          },
          callback_url: "https://example.com/callback",
        }
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2_payment_links = described_class.new(access_token)
        location_url = k2_payment_links.create_payment_link(payment_link_params)

        expect(location_url).to(eq("https://sandbox.kopokopo.com/api/v2/payment_links/f387e4d7-6a32-4f2d-ba1e-809eab2d9614"))
      end
    end

    context "without metadata" do
      it "sends a request to create a payment link" do
        stub_access_token_request
        stub_payment_link_request

        payment_link_params = {
          till_number: "4321",
          currency: "KES",
          amount: 1000,
          payment_reference: "INV02932922",
          note: "Payment for monthly internet subscription",
          callback_url: "https://example.com/callback",
        }
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2_payment_links = described_class.new(access_token)
        k2_payment_links.create_payment_link(payment_link_params)

        expect(WebMock).to(have_requested(:post, K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("payment_links")))
      end

      it "returns the created payment link's resource url" do
        stub_access_token_request
        stub_payment_link_request

        payment_link_params = {
          till_number: "4321",
          currency: "KES",
          amount: 1000,
          payment_reference: "INV02932922",
          note: "Payment for monthly internet subscription",
          callback_url: "https://example.com/callback",
        }
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2_payment_links = described_class.new(access_token)
        location_url = k2_payment_links.create_payment_link(payment_link_params)

        expect(location_url).to(eq("https://sandbox.kopokopo.com/api/v2/payment_links/f387e4d7-6a32-4f2d-ba1e-809eab2d9614"))
      end
    end

    context "without till number" do
      it "raises the correct error" do
        stub_access_token_request
        stub_payment_link_request

        payment_link_params = {
          currency: "KES",
          amount: 1000,
          payment_reference: "INV02932922",
          note: "Payment for monthly internet subscription",
          metadata: {
            account_number: "1234567",
          },
          callback_url: "https://example.com/callback",
        }
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2_payment_links = described_class.new(access_token)

        expect { k2_payment_links.create_payment_link(payment_link_params) }.to(raise_error(ArgumentError, "Till number can't be blank"))
      end
    end

    context "without currency" do
      it "raises the correct error" do
        stub_access_token_request
        stub_payment_link_request

        payment_link_params = {
          till_number: "4321",
          amount: 1000,
          payment_reference: "INV02932922",
          note: "Payment for monthly internet subscription",
          metadata: {
            account_number: "1234567",
          },
          callback_url: "https://example.com/callback",
        }
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2_payment_links = described_class.new(access_token)

        expect { k2_payment_links.create_payment_link(payment_link_params) }.to(raise_error(ArgumentError, "Currency can't be blank"))
      end
    end

    context "with invalid currency" do
      it "raises the correct error" do
        stub_access_token_request
        stub_payment_link_request

        payment_link_params = {
          till_number: "4321",
          currency: "USD",
          amount: 1000,
          payment_reference: "INV02932922",
          note: "Payment for monthly internet subscription",
          metadata: {
            account_number: "1234567",
          },
          callback_url: "https://example.com/callback",
        }
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2_payment_links = described_class.new(access_token)

        expect { k2_payment_links.create_payment_link(payment_link_params) }.to(raise_error(ArgumentError, "Currency must be 'KES'"))
      end
    end

    context "without amount" do
      it "raises the correct error" do
        stub_access_token_request
        stub_payment_link_request

        payment_link_params = {
          till_number: "4321",
          currency: "KES",
          payment_reference: "INV02932922",
          note: "Payment for monthly internet subscription",
          metadata: {
            account_number: "1234567",
          },
          callback_url: "https://example.com/callback",
        }
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2_payment_links = described_class.new(access_token)

        expect { k2_payment_links.create_payment_link(payment_link_params) }.to(raise_error(ArgumentError, "Amount can't be blank"))
      end
    end

    context "without callback url" do
      it "raises the correct error" do
        stub_access_token_request
        stub_payment_link_request

        payment_link_params = {
          till_number: "4321",
          currency: "KES",
          amount: 1000,
          payment_reference: "INV02932922",
          note: "Payment for monthly internet subscription",
          metadata: {
            account_number: "1234567",
          },
        }
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2_payment_links = described_class.new(access_token)

        expect { k2_payment_links.create_payment_link(payment_link_params) }.to(raise_error(ArgumentError, "Callback url can't be blank"))
      end
    end
  end

  describe "#cancel_payment_link" do
    it "sends request to cancel payment link" do
      stub_access_token_request
      stub_payment_link_request

      payment_link_params = {
        till_number: "4321",
        currency: "KES",
        amount: 1000,
        payment_reference: "INV02932922",
        note: "Payment for monthly internet subscription",
        metadata: {
          account_number: "1234567",
        },
        callback_url: "https://example.com/callback",
      }
      access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
      k2_payment_links = described_class.new(access_token)
      location_url = k2_payment_links.create_payment_link(payment_link_params)
      stub_payment_link_cancellation_request(location_url)
      k2_payment_links.cancel_payment_link(location_url)

      expect(WebMock).to(have_requested(:post, "#{location_url}/cancel"))
    end

    it "returns the right message" do
      stub_access_token_request
      stub_payment_link_request

      payment_link_params = {
        till_number: "4321",
        currency: "KES",
        amount: 1000,
        payment_reference: "INV02932922",
        note: "Payment for monthly internet subscription",
        metadata: {
          account_number: "1234567",
        },
        callback_url: "https://example.com/callback",
      }
      access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
      k2_payment_links = described_class.new(access_token)
      location_url = k2_payment_links.create_payment_link(payment_link_params)
      stub_payment_link_cancellation_request(location_url)
      message = k2_payment_links.cancel_payment_link(location_url)

      expect(message).to(eq("Payment link cancelled."))
    end
  end

  describe "#query_status" do
    it "sends request to fetch the latest payment link resource" do
      stub_access_token_request
      stub_payment_link_request

      payment_link_params = {
        till_number: "4321",
        currency: "KES",
        amount: 1000,
        payment_reference: "INV02932922",
        note: "Payment for monthly internet subscription",
        metadata: {
          account_number: "1234567",
        },
        callback_url: "https://example.com/callback",
      }
      access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
      k2_payment_links = described_class.new(access_token)
      location_url = k2_payment_links.create_payment_link(payment_link_params)
      stub_request(:get, location_url).to_return(status: 200, body: generate_payment_link_response.to_json)
      k2_payment_links.query_status

      expect(WebMock).to(have_requested(:get, location_url))
    end

    it "returns the correct resource details" do
      stub_access_token_request
      stub_payment_link_request

      payment_link_params = {
        till_number: "4321",
        currency: "KES",
        amount: 1000,
        payment_reference: "INV02932922",
        note: "Payment for monthly internet subscription",
        metadata: {
          account_number: "1234567",
        },
        callback_url: "https://example.com/callback",
      }
      access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
      k2_payment_links = described_class.new(access_token)
      location_url = k2_payment_links.create_payment_link(payment_link_params)
      expected_response = generate_payment_link_response
      stub_request(:get, location_url).to_return(status: 200, body: expected_response.to_json)
      payment_link_request = k2_payment_links.query_status

      expect(payment_link_request).to(eq(expected_response))
    end
  end

  describe "#query_resource" do
    it "sends request to fetch the specified payment link resource" do
      stub_access_token_request
      stub_payment_link_request

      payment_link_params = {
        till_number: "4321",
        currency: "KES",
        amount: 1000,
        payment_reference: "INV02932922",
        note: "Payment for monthly internet subscription",
        metadata: {
          account_number: "1234567",
        },
        callback_url: "https://example.com/callback",
      }
      access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
      k2_payment_links = described_class.new(access_token)
      location_url = k2_payment_links.create_payment_link(payment_link_params)
      stub_request(:get, location_url).to_return(status: 200, body: generate_payment_link_response.to_json)
      k2_payment_links.query_resource(location_url)

      expect(WebMock).to(have_requested(:get, location_url))
    end

    it "returns the correct resource details" do
      stub_access_token_request
      stub_payment_link_request

      payment_link_params = {
        till_number: "4321",
        currency: "KES",
        amount: 1000,
        payment_reference: "INV02932922",
        note: "Payment for monthly internet subscription",
        metadata: {
          account_number: "1234567",
        },
        callback_url: "https://example.com/callback",
      }
      access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
      k2_payment_links = described_class.new(access_token)
      location_url = k2_payment_links.create_payment_link(payment_link_params)
      expected_response = generate_payment_link_response
      stub_request(:get, location_url).to_return(status: 200, body: expected_response.to_json)
      payment_link_request = k2_payment_links.query_resource(location_url)

      expect(payment_link_request).to(eq(expected_response))
    end
  end

  def stub_payment_link_request
    stub_request(:post, K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("payment_links"))
      .to_return(status: 201, headers: { location: "https://sandbox.kopokopo.com/api/v2/payment_links/f387e4d7-6a32-4f2d-ba1e-809eab2d9614"})
  end

  def stub_payment_link_cancellation_request(resource_url)
    stub_request(:post, "#{resource_url}/cancel").to_return(status: 200, body: { message: "Payment link cancelled." }.to_json)
  end

  def generate_payment_link_response
    {
      data: {
        id: "f387e4d7-6a32-4f2d-ba1e-809eab2d9614",
        type: "payment_link",
        attributes: {
          status: "Processed",
          created_at: "2026-01-29T17:28:24.316+03:00",
          till_name: "The Continental Ltd - Till 1",
          till_number: "4321",
          payment_reference: "INV02932922",
          currency: "KES",
          amount: 1000,
          note: "Payment for monthly internet subscription",
          payment_link: {
            payment_link_status: "active",
            expires_at: "2026-02-05T17:28:24.337+03:00",
            initiator_name: "John Doe",
            link: "https://sandbox.kopokopo.com/links/437db08b-7f44-46e8-bbf7-f47f6d67d830",
          },
          errors: nil,
          metadata: {
            account_number: "1234567",
          },
          _links: {
            callback_url: "https://webhook.site/0079216a-77f3-49ce-812d-c7413a34342e",
            self: "https://sandbox.kopokopo.com/api/v2/payment_links/f387e4d7-6a32-4f2d-ba1e-809eab2d9614",
          },
        },
      },
    }
  end
end
