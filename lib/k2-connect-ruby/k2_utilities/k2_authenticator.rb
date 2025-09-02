# frozen_string_literal: true

require "openssl"
require "active_support/security_utils"

module K2ConnectRuby
  module K2Utilities
    module K2Authenticator
      extend self

      def authenticate(body, api_secret_key, signature)
        if body.blank? || api_secret_key.blank? || signature.blank?
          raise ArgumentError, "Nil Authentication Argument!\n Check whether your Input is Empty"
        end

        digest = OpenSSL::Digest.new("sha256")
        hmac = OpenSSL::HMAC.hexdigest(digest, api_secret_key, body.to_json)
        unless ActiveSupport::SecurityUtils.secure_compare(hmac, signature)
          raise ArgumentError, "Invalid Details Given!\n Ensure that your the Arguments Given are correct, namely:\n\t- The Response Body\n\t- Secret Key\n\t- Signature"
        end

        true
      end
    end
  end
end
