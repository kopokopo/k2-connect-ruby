RSpec.describe K2ConnectRuby::K2Utilities::Config::K2Config do
  include K2ConnectRuby::K2Utilities::Config::K2Config
  let(:k2_config) { K2ConnectRuby::K2Utilities::Config::K2Config }

  describe "#base_url=" do
    it "should raise error if not a url" do
      expect { k2_config.base_url = "url" }.to(raise_error(ArgumentError, "Invalid URL Format."))
    end

    it "should set the url" do
      base_url = "https://sandbox.kopokopo.com/"
      k2_config.base_url = base_url
      expect(k2_config.base_url).to(eql(base_url))
    end
  end

  context "get all URLs set" do
    it "should retrieve Path variable URL (Oauth Token)" do
      expect { k2_config.endpoint("oauth_token") }.not_to(raise_error)
    end

    it "should retrieve Path variable URL (Webhooks)" do
      expect { k2_config.endpoint("webhook_subscriptions") }.not_to(raise_error)
    end

    it "should retrieve Path variable URL (Outgoing payments)" do
      expect { k2_config.endpoint("pay_recipient") }.not_to(raise_error)
    end

    it "should retrieve Path variable URL (STK Push)" do
      expect { k2_config.endpoint("incoming_payments") }.not_to(raise_error)
    end

    it "should retrieve Path variable URL (Settlement Mobile Wallet)" do
      expect { k2_config.endpoint("settlement_mobile_wallet") }.not_to(raise_error)
    end

    it "should retrieve Path variable URL (Settlement Bank Account)" do
      expect { k2_config.endpoint("settlement_bank_account") }.not_to(raise_error)
    end

    it "should retrieve Path variable URL (Transfers)" do
      expect { k2_config.endpoint("transfers") }.not_to(raise_error)
    end

    it "should retrieve all Path variable URLs" do
      expect { k2_config.endpoints }.not_to(raise_error)
    end
  end
end
