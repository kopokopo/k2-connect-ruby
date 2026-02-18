RSpec.describe K2ConnectRuby::K2Entity::K2Token do
  let(:k2token) { K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret") }

  before(:each) do
    stub_request(:post, /sandbox.kopokopo.com/).to_return(status: 201, body: { access_token: "access_token" }.to_json)
  end

  describe '#initialize' do
    it 'should initialize with access_token' do
      K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret")
    end

    it 'should raise an error when there is an empty client credentials' do
      expect { K2ConnectRuby::K2Entity::K2Token.new('', '') }.to raise_error ArgumentError
    end
  end

  describe '#request_token' do
    it 'should return an access token' do
      aggregate_failures do
        expect { k2token.request_token }.not_to(raise_error)
        expect(k2token.access_token).not_to(eq(nil))
      end
    end
  end

  describe '#api errors' do
    describe '#introspect_token' do
      context 'when you pass invalid credentials' do
        it 'should raise a k2 connect unauthorized error' do
          stub_request(:post, /sandbox.kopokopo.com/).to_return(status: 401, body: { access_token: "access_token" }.to_json)

          expect do
            k2token.introspect_token("access_token")
          end.to raise_error K2ConnectRuby::K2Errors::UnauthorizedError
        end
      end

      context "when SendIntrospectTokenRequestService returns RequestTimeout error" do
        it "should throw correct error response" do
          stub_request(:post, /sandbox.kopokopo.com/).to_timeout

          expect do
            k2token.introspect_token("access_token")
          end.to raise_error K2ConnectRuby::K2Errors::TimeoutError
        end
      end

      context "when SendIntrospectTokenRequestService returns ConnectionError error" do
        it "should throw correct error response" do
          stub_request(:post, /sandbox.kopokopo.com/).to_raise(Errno::ECONNREFUSED)
          expect do
            k2token.introspect_token("access_token")
          end.to raise_error K2ConnectRuby::K2Errors::ConnectionError
        end
      end
    end

    describe '#revoke_token' do
      context 'when you pass invalid credentials' do
        it 'should raise an k2 connect unauthorized error' do
          stub_request(:post, K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("revoke_token")).to_return(status: 401, body: { access_token: "access_token" }.to_json)

          expect do
            k2token.revoke_token("access_token")
          end.to raise_error K2ConnectRuby::K2Errors::UnauthorizedError
        end
      end

      context "when SendIntrospectTokenRequestService returns RequestTimeout error" do
        it "should throw correct error response" do
          stub_request(:post, K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("revoke_token")).to_return(status: 401, body: { access_token: "access_token" }.to_json)

          expect do
            k2token.revoke_token("access_token")
          end.to raise_error K2ConnectRuby::K2Errors::UnauthorizedError
        end
      end

      context "when SendIntrospectTokenRequestService returns ConnectionError error" do
        it "should throw correct error response" do
          stub_request(:post, K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("revoke_token")).to_raise(Errno::ECONNREFUSED)
          expect do
            k2token.revoke_token("access_token")
          end.to raise_error K2ConnectRuby::K2Errors::ConnectionError
        end
      end
    end
    describe '#token_info' do
      context 'when you pass invalid credentials' do
        it 'should raise a k2 connect unauthorized error' do
          stub_request(:get, K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("token_info")).to_return(status: 401, body: { access_token: "access_token" }.to_json)

          expect do
            k2token.token_info("access_token")
          end.to raise_error K2ConnectRuby::K2Errors::UnauthorizedError
        end
      end

      context "when SendIntrospectTokenRequestService returns RequestTimeout error" do
        it "should throw correct error response" do
          stub_request(:get, K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("token_info")).to_timeout

          expect do
            k2token.token_info("access_token")
          end.to raise_error K2ConnectRuby::K2Errors::TimeoutError
        end
      end

      context "when SendIntrospectTokenRequestService returns ConnectionError error" do
        it "should throw correct error response" do
          stub_request(:get, K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("token_info")).to_raise(Errno::ECONNREFUSED)
          expect do
            k2token.token_info("access_token")
          end.to raise_error K2ConnectRuby::K2Errors::ConnectionError
        end
      end
    end
  end

  context "Other access token actions" do
    describe '#revoke_token' do
      it 'should return an access token' do
        stub_request(:post, 'https://sandbox.kopokopo.com/oauth/revoke').to_return(body: { client_id: "client_id", client_secret: "client_secret", token: "access_token" }.to_json, status: 200)
        expect { k2token.revoke_token("access_token") }.not_to(raise_error)
      end
    end

    describe '#introspect_token' do
      it 'should return an access token' do
        stub_request(:post, 'https://sandbox.kopokopo.com/oauth/introspect').to_return(body: { client_id: "client_id", client_secret: "client_secret", token: "access_token" }.to_json, status: 200)
        expect { k2token.introspect_token("access_token") }.not_to(raise_error)
      end
    end

    describe '#token_info' do
      it 'should return an access token' do
        stub_request(:get, 'https://sandbox.kopokopo.com/oauth/token/info').to_return(body: { client_id: "client_id", client_secret: "client_secret", token: "access_token" }.to_json, status: 200)
        expect { k2token.token_info("access_token") }.not_to(raise_error)
      end
    end
  end
end
