# frozen_string_literal: true

module K2ConnectRuby
  module K2Services
    class BaseService
      CallResult = Struct.new(:success?, :data, :errors) do
        class << self
          def success(data = nil)
            new(true, data, [])
          end

          def errors(messages)
            new(false, nil, messages)
          end
        end
      end

      class << self
        def call(*args, &block)
          new(*args, &block).execute
        end
      end
    end
  end
end
