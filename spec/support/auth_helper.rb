# frozen_string_literal: true

module AuthHelper
  def stub_access_token_request
    stub_request(:post, K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("oauth_token"))
      .to_return(body: { access_token: "access_token" }.to_json, status: 200)
  end
end
