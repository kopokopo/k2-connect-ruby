RSpec.describe K2Subscribe do
  before(:all) do
    @webhook_secret = 'webhook_secret'
    @k2subscriber = K2Subscribe.new('buygoods_transaction_received', @webhook_secret)
    @bg_reversed = K2Subscribe.new('buygoods_transaction_reversed', @webhook_secret)
    @customer = K2Subscribe.new('customer_created', @webhook_secret)
    @settlement = K2Subscribe.new('settlement_transfer_completed', @webhook_secret)
    @b2b = K2Subscribe.new('external_till_to_till', @webhook_secret)
    @m2m = K2Subscribe.new('k2_merchant_to_merchant', @webhook_secret)
    @k2sub_not_exist = K2Subscribe.new('event_type', @webhook_secret)
  end

  context '#initialize' do
    it 'should initialize with event_type and webhook_secret' do
      K2Subscribe.new('buygoods_transaction_received', @webhook_secret)
    end

    it 'should raise an error when there is an empty event_type' do
      expect { K2Subscribe.new('', @webhook_secret) }.to raise_error ArgumentError
    end
  end

  context '#token_request' do
    it 'raises an error if empty Credentials given' do
      expect { @k2subscriber.token_request('', nil) }.to raise_error ArgumentError
    end

    it 'should return an access token' do
      # token_request stub method
      stub_request(:post, 'https://3b815ff3-b118-4e25-8687-1e31c38a733b.mock.pstmn.io/oauth')
          .with(body: { client_id: 'client_id', client_secret: 'client_secret', grant_type: 'client_credentials' },
                headers: { 'Accept-Encoding': 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection': 'keep-alive', 'Content-Type': 'application/json', 'Keep-Alive': '30',
                           'User-Agent': 'Ruby' })
          .to_return(status: 200, body: { access_token: '123ABC456def', token_type: 'bearer', expires_in: 3_600, refresh_token: '789GHI101jkl', scope: 'read', uid: 123,
              info: { name: 'David J. Kariuki', email: 'dijon@david.yoh' } }.to_json, headers: {})

      expect { @k2subscriber.token_request('client_id', 'client_secret') }.not_to raise_error
      expect(@k2subscriber.access_token).to eq('123ABC456def')
    end
  end

  context '#webhook_subscribe' do
    it 'raise error if event type does not match' do
      expect { @k2sub_not_exist.webhook_subscribe }.to raise_error ArgumentError
    end

    it 'should send webhook subscription for buy goods received' do
      # webhook_subscribe buy goods received stub method
      stub_request(:post, 'https://3b815ff3-b118-4e25-8687-1e31c38a733b.mock.pstmn.io/webhook-subscription')
          .with(body: { event_type: 'buygoods_transaction_received', url: 'https://myapplication.com/webhooks', secret: 'webhook_secret' },
                headers: { 'Accept': %w(*/* application/json), 'Accept-Encoding': 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection': 'keep-alive', 'Content-Type': 'application/json', 'Keep-Alive': '30',
                           'User-Agent': 'Ruby' })
          .to_return(status: 200, body: '', headers: {})

      expect { @k2subscriber.webhook_subscribe }.not_to raise_error
    end

    it 'should send webhook subscription for buy goods reversed' do
      # webhook_subscribe buy goods reversed stub method
      stub_request(:post, 'https://3b815ff3-b118-4e25-8687-1e31c38a733b.mock.pstmn.io/buygoods-transaction-reversed')
          .with(body: { event_type: 'buygooods_transaction_reversed', url: 'https://myapplication.com/webhooks', secret: 'webhook_secret' },
                headers: { 'Accept': %w(*/* application/json), 'Accept-Encoding': 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection': 'keep-alive', 'Content-Type': 'application/json', 'Keep-Alive': '30',
                           'User-Agent': 'Ruby' })
          .to_return(status: 200, body: '', headers: {})

      expect { @bg_reversed.webhook_subscribe }.not_to raise_error
    end

    it 'should send webhook subscription for customer created' do
      # webhook_subscribe customer created stub method
      stub_request(:post, 'https://3b815ff3-b118-4e25-8687-1e31c38a733b.mock.pstmn.io/customer-created')
          .with(body: { event_type: 'customer_created', url: 'https://myapplication.com/webhooks', secret: 'webhook_secret' },
                headers: { 'Accept': %w(*/* application/json), 'Accept-Encoding': 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection': 'keep-alive', 'Content-Type': 'application/json', 'Keep-Alive': '30',
                           'User-Agent': 'Ruby' })
          .to_return(status: 200, body: '', headers: {})

      expect { @customer.webhook_subscribe }.not_to raise_error
    end

    it 'should send webhook subscription for settlement' do
      # webhook_subscribe settlement stub method
      stub_request(:post, 'https://3b815ff3-b118-4e25-8687-1e31c38a733b.mock.pstmn.io/settlement')
          .with(body: { event_type: 'settlement', url: 'https://myapplication.com/webhooks', secret: 'webhook_secret' },
                headers: { 'Accept': %w(*/* application/json), 'Accept-Encoding': 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection': 'keep-alive', 'Content-Type': 'application/json', 'Keep-Alive': '30',
                           'User-Agent': 'Ruby' })
          .to_return(status: 200, body: '', headers: {})

      expect { @settlement.webhook_subscribe }.not_to raise_error
    end

    it 'should send webhook subscription for external till to till (b2b)' do
      # webhook_subscribe external till to till (b2b) stub method
      stub_request(:post, 'https://3b815ff3-b118-4e25-8687-1e31c38a733b.mock.pstmn.io/b2b-transaction-received')
          .with(body: { event_type: 'b2b_transaction_received', url: 'https://myapplication.com/webhooks', secret: 'webhook_secret' },
                headers: { 'Accept': %w(*/* application/json), 'Accept-Encoding': 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection': 'keep-alive', 'Content-Type': 'application/json', 'Keep-Alive': '30',
                           'User-Agent': 'Ruby' })
          .to_return(status: 200, body: '', headers: {})

      expect { @b2b.webhook_subscribe }.not_to raise_error
    end

    it 'should send webhook subscription for merchant to merchant transaction' do
      # webhook_subscribe merchant to merchant transaction stub method
      stub_request(:post, 'https://3b815ff3-b118-4e25-8687-1e31c38a733b.mock.pstmn.io/merchant-to-merchant')
          .with(body: { event_type: 'merchant_to_merchant', url: 'https://myapplication.com/webhooks', secret: 'webhook_secret' },
                headers: { 'Accept': %w(*/* application/json), 'Accept-Encoding': 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection': 'keep-alive', 'Content-Type': 'application/json', 'Keep-Alive': '30',
                           'User-Agent': 'Ruby' })
          .to_return(status: 200, body: '', headers: {})

      expect { @m2m.webhook_subscribe }.not_to raise_error
    end
  end
end
