include SpecStubRequest
RSpec.describe K2AccessToken do
  before(:all) do
    @token_request_body = { client_id: @client_id, client_secret: @client_secret, grant_type: 'client_credentials' }
    @token_response_body = { access_token: "EGkprnabmZK48I8rXZF6N2SYt9ztkGi0bX1a4e4m3J4", token_type: "Bearer", expires_in: 7200, created_at: 1579597184 }
  end

  context '#initialize' do
    it 'should initialize with access_token' do
      K2AccessToken.new('BwuGu77i5M0SdCc9-R8haR3v0rIR5XsG4xYte27zxjs', '42aPhB6gF7u5n-r0-aL7fQkOVHAzoIYNPr4Nw-wCxQE')
    end

    it 'should raise an error when there is an empty client credentials' do
      expect { K2AccessToken.new('', '') }.to raise_error ArgumentError
    end
  end

  context '#request_token' do
    let(:k2token) { K2AccessToken.new('BwuGu77i5M0SdCc9-R8haR3v0rIR5XsG4xYte27zxjs', '42aPhB6gF7u5n-r0-aL7fQkOVHAzoIYNPr4Nw-wCxQE') }
    it 'should return an access token' do
      #test_response = SpecStubRequest.stub_request('post', K2Config.path_variable('oauth_token'), @token_request_body, 200, nil, @token_response_body)
      expect { k2token.request_token }.not_to raise_error
      expect(k2token.access_token).not_to eq(nil)
    end
  end
end