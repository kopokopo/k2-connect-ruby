# frozen_string_literal: true

module K2ConnectRuby
  module K2Utilities
    module Config
      module K2Config
        @config = YAML.load_file(
          File.join(File.dirname(__FILE__), "k2_config.yml"), permitted_classes: [ActiveSupport::HashWithIndifferentAccess]
        ).with_indifferent_access

        class << self
          # Set the Host Url
          def set_base_url(base_url)
            raise(ArgumentError, "Invalid URL Format.") unless base_url =~ /\A#{URI.regexp(%w[http https])}\z/

            @config[:base_url] = base_url
            File.open(File.join(File.dirname(__FILE__), "k2_config.yml"), "w") { |f| YAML.dump(@config, f) }
          end

          def base_url
            @config[:base_url]
          end

          def endpoints
            @config[:endpoints]
          end

          def endpoint(key)
            base_url + path(key)
          end

          def path(key)
            return @config[:endpoints][:"#{key}"].to_s unless key.include?("token")

            @config[:endpoints][:"#{key}"]
          end

          def network_operators
            @config[:network_operators]
          end
        end

      end
    end
  end
end
