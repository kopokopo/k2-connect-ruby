# frozen_string_literal: true

RSpec.describe K2ConnectRuby::K2Services::SendRequestTokenRequestService do
  describe '#call' do
    context 'when you pass invalid credentials' do
      it 'should raise a k2 connect unauthorized error' do
        stub_request(:post, K2ConnectRuby::K2Utilities::Config::K2Config.endpoint('oauth_token'))
          .to_return(body: { access_token: 'access_token' }.to_json, status: 401)
        expect do
          K2ConnectRuby::K2Services::SendRequestTokenRequestService.call('client_id', 'wrong_client_secret')
        end.to raise_error K2ConnectRuby::K2Errors::UnauthorizedError
      end
    end

    context 'when the api has a timeout' do
      it 'should raise a k2 connect timeout error' do
        stub_request(:post, K2ConnectRuby::K2Utilities::Config::K2Config.endpoint('oauth_token'))
          .to_timeout
        expect do
          K2ConnectRuby::K2Services::SendRequestTokenRequestService.call('client_id', 'client_secret')
        end.to raise_error K2ConnectRuby::K2Errors::TimeoutError
      end
    end

    context 'when the api has a connection refused' do
      it 'should raise a k2 connect connection refused' do
        stub_request(:post, K2ConnectRuby::K2Utilities::Config::K2Config.endpoint('oauth_token'))
          .to_raise(Errno::ECONNREFUSED)
        expect do
          K2ConnectRuby::K2Services::SendRequestTokenRequestService.call('client_id', 'client_secret')
        end.to raise_error K2ConnectRuby::K2Errors::ConnectionError
      end
    end

    context 'when the api has an uncaught error' do
      it 'should raise a generic k2 connect api error' do
        stub_request(:post, K2ConnectRuby::K2Utilities::Config::K2Config.endpoint('oauth_token'))
          .to_return(status: 500, body: { error_message: 'internal server error' }.to_json)
        expect do
          K2ConnectRuby::K2Services::SendRequestTokenRequestService.call('client_id', 'client_secret')
        end.to raise_error K2ConnectRuby::K2Errors::ApiError
      end

      it 'should raise with the correct error message' do
        stub_request(:post, K2ConnectRuby::K2Utilities::Config::K2Config.endpoint('oauth_token'))
          .to_return(status: 500, body: { error_message: 'internal server error' }.to_json)

        begin
          K2ConnectRuby::K2Services::SendRequestTokenRequestService.call('client_id', 'client_secret')
        rescue K2ConnectRuby::K2Errors::ApiError => e
          expect(e.code).to eq(500)
        end
      end

      it 'exposes the API error message details' do
        stub_request(:post, K2ConnectRuby::K2Utilities::Config::K2Config.endpoint('oauth_token'))
          .to_return(status: 500, body: { error_message: 'internal server error' }.to_json)

        begin
          K2ConnectRuby::K2Services::SendRequestTokenRequestService.call('client_id', 'client_secret')
        rescue K2ConnectRuby::K2Errors::ApiError => e
          expect(e.details['error_message']).to eq('internal server error')
        end
      end
    end
  end
end
