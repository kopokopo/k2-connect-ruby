class K2Authenticator
  # Compares HMAC signature with the key. Later call it K2Authenticator
  def authenticate?(body, api_secret_key, signature)
    raise K2NilAuthArgument if body.nil? || api_secret_key.nil? || signature.nil?
    digest = OpenSSL::Digest.new('sha256')
    hmac = OpenSSL::HMAC.hexdigest(digest, api_secret_key, body.to_json)
    if ActiveSupport::SecurityUtils.secure_compare(hmac, signature)
      return true
    else
      raise K2InvalidHMAC
    end
  rescue K2NilAuthArgument => k2
    puts(k2.message)
  rescue K2InvalidHMAC => k3
    puts(k3.message)
  rescue StandardError => e
    puts(e.message)
  end
end