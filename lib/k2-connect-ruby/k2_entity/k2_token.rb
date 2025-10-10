# frozen_string_literal: true

module K2ConnectRuby
  module K2Entity
    class K2Token
      attr_reader :access_token, :token_response

      def initialize(client_id, client_secret)
        validate_client_credentials(client_id, client_secret)
        @client_id = client_id
        @client_secret = client_secret
      end

      def request_token
        result = K2ConnectRuby::K2Services::SendRequestTokenRequestService.call(@client_id, @client_secret)

        if result.success?
          @access_token = result.data[:response_body][:access_token]
        else
          raise(result.errors.first)
        end
      end

      def revoke_token(access_token)
        result = K2ConnectRuby::K2Services::SendRevokeTokenRequestService.call(@client_id, @client_secret, access_token)

        if result.success?
          true
        else
          raise(result.errors.first)
        end
      end

      def introspect_token(access_token)
        result = K2ConnectRuby::K2Services::SendIntrospectTokenRequestService.call(@client_id, @client_secret, access_token)

        if result.success?
          result.data[:response_body]
        else
          raise(result.errors.first)
        end
      end

      def token_info(access_token)
        result = K2ConnectRuby::K2Services::SendTokenInfoRequestService.call(access_token)

        if result.success?
          result.data[:response_body]
        else
          raise(result.errors.first)
        end
      end

      def validate_client_credentials(client_id, client_secret)
        raise ArgumentError, "Nil or Empty Client Id or Secret!" if client_id.blank? || client_secret.blank?
      end
    end
  end
end
