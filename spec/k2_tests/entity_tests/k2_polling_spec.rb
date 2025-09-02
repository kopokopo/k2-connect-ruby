# frozen_string_literal: true

require "faker"

RSpec.describe(K2ConnectRuby::K2Entity::K2Polling) do
  context "Till scope" do
    describe "#poll" do
      it "should create polling request" do
        stub_access_token_request
        stub_polling_request
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2_polling = K2ConnectRuby::K2Entity::K2Polling.new(access_token)
        till_polling_payload = HashWithIndifferentAccess.new(
          scope: "till",
          scope_reference: 112233,
          from_time: Time.now - 14400,
          to_time: Time.now,
          callback_url: Faker::Internet.url
        )

        aggregate_failures do
          expect { k2_polling.poll(till_polling_payload) }.not_to(raise_error)
          expect(WebMock).to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("poll"))))
        end
      end

      it "returns a location_url" do
        stub_access_token_request
        stub_polling_request
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2_polling = K2ConnectRuby::K2Entity::K2Polling.new(access_token)
        till_polling_payload = HashWithIndifferentAccess.new(
          scope: "till",
          scope_reference: 112233,
          from_time: Time.now - 14400,
          to_time: Time.now,
          callback_url: Faker::Internet.url
        )
        k2_polling.poll(till_polling_payload)
        expect(k2_polling.location_url).not_to(eq(nil))
      end

      context "with invalid details" do
        context "no from_time" do
          it "raises an error and does not send a request" do
            stub_access_token_request
            stub_polling_request
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2_polling = K2ConnectRuby::K2Entity::K2Polling.new(access_token)
            till_polling_payload = HashWithIndifferentAccess.new(
              scope: "till",
              scope_reference: 112233,
              from_time: nil,
              to_time: Time.now,
              callback_url: Faker::Internet.url
            )

            aggregate_failures do
              expect { k2_polling.poll(till_polling_payload) }.to(raise_error(ArgumentError, "From time can't be blank"))
              expect(WebMock).to_not(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("poll"))))
            end
          end
        end

        context "no to_time" do
          it "raises an error and does not send a request" do
            stub_access_token_request
            stub_polling_request
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2_polling = K2ConnectRuby::K2Entity::K2Polling.new(access_token)
            till_polling_payload = HashWithIndifferentAccess.new(
              scope: "till",
              scope_reference: 112233,
              from_time: Time.now - 14400,
              to_time: nil,
              callback_url: Faker::Internet.url
            )

            aggregate_failures do
              expect { k2_polling.poll(till_polling_payload) }.to(raise_error(ArgumentError, "To time can't be blank"))
              expect(WebMock).to_not(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("poll"))))
            end
          end
        end

        context "no callback_url" do
          it "raises an error and does not send a request" do
            stub_access_token_request
            stub_polling_request
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2_polling = K2ConnectRuby::K2Entity::K2Polling.new(access_token)
            till_polling_payload = HashWithIndifferentAccess.new(
              scope: "till",
              scope_reference: 112233,
              from_time: Time.now - 14400,
              to_time: Time.now,
              callback_url: nil
            )

            aggregate_failures do
              expect { k2_polling.poll(till_polling_payload) }.to(raise_error(ArgumentError, "Callback url can't be blank"))
              expect(WebMock).to_not(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("poll"))))
            end
          end
        end

        context "no scope" do
          it "raises an error and does not send a request" do
            stub_access_token_request
            stub_polling_request
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2_polling = K2ConnectRuby::K2Entity::K2Polling.new(access_token)
            till_polling_payload = HashWithIndifferentAccess.new(
              scope: nil,
              scope_reference: 112233,
              from_time: Time.now - 14400,
              to_time: Time.now,
              callback_url: Faker::Internet.url
            )

            aggregate_failures do
              expect { k2_polling.poll(till_polling_payload) }.to(raise_error(ArgumentError, "Scope can't be blank"))
              expect(WebMock).to_not(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("poll"))))
            end
          end
        end

        context "invalid scope" do
          it "raises an error and does not send a request" do
            stub_access_token_request
            stub_polling_request
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2_polling = K2ConnectRuby::K2Entity::K2Polling.new(access_token)
            till_polling_payload = HashWithIndifferentAccess.new(
              scope: "scope",
              scope_reference: 112233,
              from_time: Time.now - 14400,
              to_time: Time.now,
              callback_url: Faker::Internet.url
            )

            aggregate_failures do
              expect { k2_polling.poll(till_polling_payload) }.to(raise_error(ArgumentError, "Scope must be one of 'till' or 'company'."))
              expect(WebMock).to_not(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("poll"))))
            end
          end
        end

        context "no scope_reference" do
          it "raises an error and does not send a request" do
            stub_access_token_request
            stub_polling_request
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2_polling = K2ConnectRuby::K2Entity::K2Polling.new(access_token)
            till_polling_payload = HashWithIndifferentAccess.new(
              scope: "till",
              scope_reference: nil,
              from_time: Time.now - 14400,
              to_time: Time.now,
              callback_url: Faker::Internet.url
            )

            aggregate_failures do
              expect { k2_polling.poll(till_polling_payload) }.to(raise_error(ArgumentError, "Scope reference can't be blank"))
              expect(WebMock).to_not(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("poll"))))
            end
          end
        end
      end
    end

    describe "#query_resource" do
      it "should query creating verified settlement account status" do
        stub_access_token_request
        stub_polling_request
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2_polling = K2ConnectRuby::K2Entity::K2Polling.new(access_token)
        till_polling_payload = HashWithIndifferentAccess.new(
          scope: "till",
          scope_reference: 112233,
          from_time: Time.now - 14400,
          to_time: Time.now,
          callback_url: Faker::Internet.url
        )
        k2_polling.poll(till_polling_payload)
        stub_request(:get, k2_polling.location_url).to_return(status: 200, body: {data: "some_data"}.to_json)
        aggregate_failures do
          expect { k2_polling.query_resource }.not_to(raise_error)
          expect(k2_polling.k2_response_body).not_to(eq(nil))
          expect(WebMock).to(have_requested(:get, K2ConnectRuby::K2Utilities::K2UrlParse.remove_localhost(URI.parse(k2_polling.location_url))))
        end
      end
    end

    describe "#query_resource_url" do
      it "should query creating verified settlement account status" do
        stub_access_token_request
        stub_polling_request
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2_polling = K2ConnectRuby::K2Entity::K2Polling.new(access_token)
        till_polling_payload = HashWithIndifferentAccess.new(
          scope: "till",
          scope_reference: 112233,
          from_time: Time.now - 14400,
          to_time: Time.now,
          callback_url: Faker::Internet.url
        )
        k2_polling.poll(till_polling_payload)
        stub_request(:get, k2_polling.location_url).to_return(status: 200, body: {data: "some_data"}.to_json)
        aggregate_failures do
          expect { k2_polling.query_resource_url(k2_polling.location_url) }.not_to(raise_error)
          expect(k2_polling.k2_response_body).not_to(eq(nil))
          expect(WebMock).to(have_requested(:get, K2ConnectRuby::K2Utilities::K2UrlParse.remove_localhost(URI.parse(k2_polling.location_url))))
        end
      end
    end
  end

  context "Company scope" do
    describe "#poll" do
      it "should create polling request" do
        stub_access_token_request
        stub_polling_request
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2_polling = K2ConnectRuby::K2Entity::K2Polling.new(access_token)
        company_polling_payload = HashWithIndifferentAccess.new(
          scope: "company",
          scope_reference: nil,
          from_time: Time.now - 14400,
          to_time: Time.now,
          callback_url: Faker::Internet.url
        )

        aggregate_failures do
          expect { k2_polling.poll(company_polling_payload) }.not_to(raise_error)
          expect(WebMock).to(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("poll"))))
        end
      end

      it "returns a location_url" do
        stub_access_token_request
        stub_polling_request
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2_polling = K2ConnectRuby::K2Entity::K2Polling.new(access_token)
        company_polling_payload = HashWithIndifferentAccess.new(
          scope: "company",
          scope_reference: nil,
          from_time: Time.now - 14400,
          to_time: Time.now,
          callback_url: Faker::Internet.url
        )
        k2_polling.poll(company_polling_payload)
        expect(k2_polling.location_url).not_to(eq(nil))
      end

      context "with invalid details" do
        context "no from_time" do
          it "raises an error and does not send a request" do
            stub_access_token_request
            stub_polling_request
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2_polling = K2ConnectRuby::K2Entity::K2Polling.new(access_token)
            company_polling_payload = HashWithIndifferentAccess.new(
              scope: "company",
              scope_reference: nil,
              from_time: nil,
              to_time: Time.now,
              callback_url: Faker::Internet.url
            )

            aggregate_failures do
              expect { k2_polling.poll(company_polling_payload) }.to(raise_error(ArgumentError, "From time can't be blank"))
              expect(WebMock).to_not(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("poll"))))
            end
          end
        end

        context "no to_time" do
          it "raises an error and does not send a request" do
            stub_access_token_request
            stub_polling_request
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2_polling = K2ConnectRuby::K2Entity::K2Polling.new(access_token)
            company_polling_payload = HashWithIndifferentAccess.new(
              scope: "company",
              scope_reference: nil,
              from_time: Time.now - 14400,
              to_time: nil,
              callback_url: Faker::Internet.url
            )

            aggregate_failures do
              expect { k2_polling.poll(company_polling_payload) }.to(raise_error(ArgumentError, "To time can't be blank"))
              expect(WebMock).to_not(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("poll"))))
            end
          end
        end

        context "no callback_url" do
          it "raises an error and does not send a request" do
            stub_access_token_request
            stub_polling_request
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2_polling = K2ConnectRuby::K2Entity::K2Polling.new(access_token)
            company_polling_payload = HashWithIndifferentAccess.new(
              scope: "company",
              scope_reference: nil,
              from_time: Time.now - 14400,
              to_time: Time.now,
              callback_url: nil
            )

            aggregate_failures do
              expect { k2_polling.poll(company_polling_payload) }.to(raise_error(ArgumentError, "Callback url can't be blank"))
              expect(WebMock).to_not(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("poll"))))
            end
          end
        end

        context "no scope" do
          it "raises an error and does not send a request" do
            stub_access_token_request
            stub_polling_request
            access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
            k2_polling = K2ConnectRuby::K2Entity::K2Polling.new(access_token)
            company_polling_payload = HashWithIndifferentAccess.new(
              scope: nil,
              scope_reference: nil,
              from_time: Time.now - 14400,
              to_time: Time.now,
              callback_url: Faker::Internet.url
            )

            aggregate_failures do
              expect { k2_polling.poll(company_polling_payload) }.to(raise_error(ArgumentError, "Scope can't be blank"))
              expect(WebMock).to_not(have_requested(:post, URI.parse(K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("poll"))))
            end
          end
        end
      end
    end

    describe "#query_resource" do
      it "should query creating verified settlement account status" do
        stub_access_token_request
        stub_polling_request
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2_polling = K2ConnectRuby::K2Entity::K2Polling.new(access_token)
        company_polling_payload = HashWithIndifferentAccess.new(
          scope: "company",
          scope_reference: nil,
          from_time: Time.now - 14400,
          to_time: Time.now,
          callback_url: Faker::Internet.url
        )
        k2_polling.poll(company_polling_payload)
        stub_request(:get, k2_polling.location_url).to_return(status: 200, body: {data: "some_data"}.to_json)
        aggregate_failures do
          expect { k2_polling.query_resource }.not_to(raise_error)
          expect(k2_polling.k2_response_body).not_to(eq(nil))
          expect(WebMock).to(have_requested(:get, K2ConnectRuby::K2Utilities::K2UrlParse.remove_localhost(URI.parse(k2_polling.location_url))))
        end
      end
    end

    describe "#query_resource_url" do
      it "should query creating verified settlement account status" do
        stub_access_token_request
        stub_polling_request
        access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
        k2_polling = K2ConnectRuby::K2Entity::K2Polling.new(access_token)
        company_polling_payload = HashWithIndifferentAccess.new(
          scope: "company",
          scope_reference: nil,
          from_time: Time.now - 14400,
          to_time: Time.now,
          callback_url: Faker::Internet.url
        )
        k2_polling.poll(company_polling_payload)
        stub_request(:get, k2_polling.location_url).to_return(status: 200, body: {data: "some_data"}.to_json)
        aggregate_failures do
          expect { k2_polling.query_resource_url(k2_polling.location_url) }.not_to(raise_error)
          expect(k2_polling.k2_response_body).not_to(eq(nil))
          expect(WebMock).to(have_requested(:get, K2ConnectRuby::K2Utilities::K2UrlParse.remove_localhost(URI.parse(k2_polling.location_url))))
        end
      end
    end
  end

  def stub_access_token_request
    stub_request(:post, "https://sandbox.kopokopo.com/oauth/token")
      .to_return(body: { access_token: "access_token" }.to_json, status: 200)
  end

  def stub_polling_request
    stub_request(:post, "https://sandbox.kopokopo.com/api/v1/polling")
      .to_return(status: 201, body: { data: "some_data" }.to_json, headers: { location: Faker::Internet.url })
  end
end
