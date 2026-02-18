# frozen_string_literal: true

RSpec.describe K2ConnectRuby::K2Services::SendK2ConnectPostRequestService do
  describe '#call' do
    context 'when you pass invalid credentials' do
      it 'should raise n k2 connect unauthorized error' do
        pay_recipient_url = 'some-url'
        stub_request(:post, pay_recipient_url)
          .to_return(body: { access_token: 'access_token' }.to_json, status: 401)
        expect do
          K2ConnectRuby::K2Services::SendK2ConnectPostRequestService.call(
            'access_token',
            pay_recipient_url,
            {}
          )
        end.to raise_error K2ConnectRuby::K2Errors::UnauthorizedError
      end
    end

    context 'when the api has a timeout' do
      it 'should raise a k2 connect timeout error' do
        pay_recipient_url = 'some-url'
        stub_request(:post, pay_recipient_url).to_timeout
        expect do
          K2ConnectRuby::K2Services::SendK2ConnectPostRequestService.call(
            'access_token',
            pay_recipient_url,
            {}
          )
        end.to raise_error K2ConnectRuby::K2Errors::TimeoutError
      end
    end

    context 'when the api has a connection refused' do
      it 'should raise a k2 connect connection refused' do
        pay_recipient_url = 'some-url'
        stub_request(:post, pay_recipient_url).to_raise(Errno::ECONNREFUSED)
        expect do
          K2ConnectRuby::K2Services::SendK2ConnectPostRequestService.call(
            'access_token',
            pay_recipient_url,
            {}
          )
        end.to raise_error K2ConnectRuby::K2Errors::ConnectionError
      end
    end

    context 'when the api has a uncaught error' do
      it 'should raise a generic k2 connect api error' do
        pay_recipient_url = 'some-url'
        stub_request(:post, pay_recipient_url).to_return(status: 500,
                                                         body: { error_message: 'internal server error' }.to_json)
        expect do
          K2ConnectRuby::K2Services::SendK2ConnectPostRequestService.call(
            'access_token',
            pay_recipient_url,
            {}
          )
        end.to raise_error K2ConnectRuby::K2Errors::ApiError
      end

      it 'should raise with the correct error message' do
        pay_recipient_url = 'some-url'
        stub_request(:post, pay_recipient_url).to_return(status: 500,
                                                         body: { error_message: 'internal server error' }.to_json)
        begin
          K2ConnectRuby::K2Services::SendK2ConnectPostRequestService.call(
            'access_token',
            pay_recipient_url,
            {}
          )
        rescue K2ConnectRuby::K2Errors::ApiError => e
          expect(e.code).to eq(500)
        end
      end

      it 'exposes the API error message details' do
        pay_recipient_url = 'some-url'
        stub_request(:post, pay_recipient_url).to_return(status: 500,
                                                         body: { error_message: 'internal server error' }.to_json)
        begin
          K2ConnectRuby::K2Services::SendK2ConnectPostRequestService.call(
            'access_token',
            pay_recipient_url,
            {}
          )
        rescue K2ConnectRuby::K2Errors::ApiError => e
          expect(e.details['error_message']).to eq('internal server error')
        end
      end
    end
  end
end
