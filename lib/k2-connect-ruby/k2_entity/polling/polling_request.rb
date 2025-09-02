# frozen_string_literal: true

module K2ConnectRuby
  module K2Entity
    module K2FinancialEntities
      module Polling
        class PollingRequest
          include ActiveModel::Validations

          attr_accessor :from_time, :to_time, :callback_url, :scope, :scope_reference

          validates :from_time, :to_time, :callback_url, :scope, presence: true
          validates :scope_reference, presence: true, if: :till_scope?
          validates :scope, inclusion: {
            in: ["till", "company"],
            message: "must be one of 'till' or 'company'.",
          }

          def initialize(kwargs)
            kwargs.each do |key, value|
              instance_variable_set("@#{key}", value)
            end
          end

          def endpoint
            K2ConnectRuby::K2Utilities::Config::K2Config.endpoint("poll")
          end

          def request_body
            {
              scope: scope,
              scope_reference: scope_reference,
              from_time: from_time,
              to_time: to_time,
              _links: {
                callback_url: callback_url,
              },
            }
          end

          def till_scope?
            scope == "till"
          end
        end
      end
    end
  end
end
