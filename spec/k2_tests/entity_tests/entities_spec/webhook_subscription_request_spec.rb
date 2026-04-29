# frozen_string_literal: true

require "faker"

RSpec.describe(K2ConnectRuby::K2Entity::K2FinancialEntities::Webhook::WebhookSubscriptionRequest) do
  describe "#new" do
    context "when initialized with all valid attributes" do
      it "has a valid object" do
        params = {
          event_type: "buygoods_transaction_received",
          url: Faker::Internet.url,
          scope: "till",
          scope_reference: "112233",
          enable_daraja_payload: true,
        }
        webhook_subscription_request = K2ConnectRuby::K2Entity::K2FinancialEntities::Webhook::WebhookSubscriptionRequest.new(params)
        expect(webhook_subscription_request).to(be_valid)
      end

      it "sets event_type attribute appropriately" do
        params = {
          event_type: "buygoods_transaction_received",
          url: Faker::Internet.url,
          scope: "till",
          scope_reference: "112233",
          enable_daraja_payload: true,
        }
        webhook_subscription_request = K2ConnectRuby::K2Entity::K2FinancialEntities::Webhook::WebhookSubscriptionRequest.new(params)
        expect(webhook_subscription_request.event_type).to(eql(params[:event_type]))
      end

      it "sets url attribute appropriately" do
        params = {
          event_type: "buygoods_transaction_received",
          url: Faker::Internet.url,
          scope: "till",
          scope_reference: "112233",
          enable_daraja_payload: true,
        }
        webhook_subscription_request = K2ConnectRuby::K2Entity::K2FinancialEntities::Webhook::WebhookSubscriptionRequest.new(params)
        expect(webhook_subscription_request.url).to(eql(params[:url]))
      end

      it "sets scope attribute appropriately" do
        params = {
          event_type: "buygoods_transaction_received",
          url: Faker::Internet.url,
          scope: "till",
          scope_reference: "112233",
          enable_daraja_payload: true,
        }
        webhook_subscription_request = K2ConnectRuby::K2Entity::K2FinancialEntities::Webhook::WebhookSubscriptionRequest.new(params)
        expect(webhook_subscription_request.scope).to(eql(params[:scope]))
      end

      it "sets scope_reference attribute appropriately" do
        params = {
          event_type: "buygoods_transaction_received",
          url: Faker::Internet.url,
          scope: "till",
          scope_reference: "112233",
          enable_daraja_payload: true,
        }
        webhook_subscription_request = K2ConnectRuby::K2Entity::K2FinancialEntities::Webhook::WebhookSubscriptionRequest.new(params)
        expect(webhook_subscription_request.scope_reference).to(eql(params[:scope_reference]))
      end

      it "sets enable_daraja_payload attribute appropriately" do
        params = {
          event_type: "buygoods_transaction_received",
          url: Faker::Internet.url,
          scope: "till",
          scope_reference: "112233",
          enable_daraja_payload: true,
        }
        webhook_subscription_request = K2ConnectRuby::K2Entity::K2FinancialEntities::Webhook::WebhookSubscriptionRequest.new(params)
        expect(webhook_subscription_request.enable_daraja_payload).to(eql(params[:enable_daraja_payload]))
      end
    end

    context "when initialized with invalid attributes" do
      context "with and invalid event type" do
        it "returns an invalid webhook_subscription_request" do
          params = {
            event_type: "invalid",
            url: Faker::Internet.url,
            scope: "till",
            scope_reference: "112233",
            enable_daraja_payload: true,
          }
          webhook_subscription_request = K2ConnectRuby::K2Entity::K2FinancialEntities::Webhook::WebhookSubscriptionRequest.new(params)
          aggregate_failures do
            expect(webhook_subscription_request).to_not(be_valid)
            expect(webhook_subscription_request.errors.full_messages).to(include("Event type is invalid"))
          end
        end
      end

      context "with an empty event type" do
        it "returns an invalid webhook_subscription_request" do
          params = {
            event_type: nil,
            url: Faker::Internet.url,
            scope: "till",
            scope_reference: "112233",
            enable_daraja_payload: true,
          }
          webhook_subscription_request = K2ConnectRuby::K2Entity::K2FinancialEntities::Webhook::WebhookSubscriptionRequest.new(params)
          aggregate_failures do
            expect(webhook_subscription_request).to_not(be_valid)
            expect(webhook_subscription_request.errors.full_messages).to(include("Event type can't be blank"))
          end
        end
      end

      context "with an empty url" do
        it "returns an invalid webhook_subscription_request" do
          params = {
            event_type: "buygoods_transaction_received",
            url: nil,
            scope: "till",
            scope_reference: "112233",
            enable_daraja_payload: true,
          }
          webhook_subscription_request = K2ConnectRuby::K2Entity::K2FinancialEntities::Webhook::WebhookSubscriptionRequest.new(params)
          aggregate_failures do
            expect(webhook_subscription_request).to_not(be_valid)
            expect(webhook_subscription_request.errors.full_messages).to(include("Url can't be blank"))
          end
        end
      end

      context "with an empty scope" do
        it "returns an invalid webhook_subscription_request" do
          params = {
            event_type: "buygoods_transaction_received",
            url: Faker::Internet.url,
            scope: nil,
            scope_reference: "112233",
            enable_daraja_payload: true,
          }
          webhook_subscription_request = K2ConnectRuby::K2Entity::K2FinancialEntities::Webhook::WebhookSubscriptionRequest.new(params)
          aggregate_failures do
            expect(webhook_subscription_request).to_not(be_valid)
            expect(webhook_subscription_request.errors.full_messages).to(include("Scope can't be blank"))
          end
        end
      end

      context "with an invalid scope" do
        it "returns an invalid webhook_subscription_request" do
          params = {
            event_type: "buygoods_transaction_received",
            url: Faker::Internet.url,
            scope: "scope",
            scope_reference: "112233",
            enable_daraja_payload: true,
          }
          webhook_subscription_request = K2ConnectRuby::K2Entity::K2FinancialEntities::Webhook::WebhookSubscriptionRequest.new(params)
          aggregate_failures do
            expect(webhook_subscription_request).to_not(be_valid)
            expect(webhook_subscription_request.errors.full_messages).to(include("Scope must be one of 'till' or 'company'."))
          end
        end
      end

      context "with an empty scope_reference for till scope" do
        it "returns an invalid webhook_subscription_request" do
          params = {
            event_type: "buygoods_transaction_received",
            url: Faker::Internet.url,
            scope: "till",
            scope_reference: nil,
            enable_daraja_payload: true,
          }
          webhook_subscription_request = K2ConnectRuby::K2Entity::K2FinancialEntities::Webhook::WebhookSubscriptionRequest.new(params)
          aggregate_failures do
            expect(webhook_subscription_request).to_not(be_valid)
            expect(webhook_subscription_request.errors.full_messages).to(include("Scope reference can't be blank"))
          end
        end
      end

      context "with daraja_payload enabled for non C2B or B2B webhooks" do
        it "returns an invalid webhook_subscription_request" do
          params = {
            event_type: "buygoods_transaction_received",
            url: Faker::Internet.url,
            scope: "till",
            scope_reference: nil,
            enable_daraja_payload: true,
          }
          webhook_subscription_request = K2ConnectRuby::K2Entity::K2FinancialEntities::Webhook::WebhookSubscriptionRequest.new(params)
          aggregate_failures do
            expect(webhook_subscription_request).to_not(be_valid)
            expect(webhook_subscription_request.errors.full_messages).to(include("Scope reference can't be blank"))
          end
        end
      end
    end
  end
end
