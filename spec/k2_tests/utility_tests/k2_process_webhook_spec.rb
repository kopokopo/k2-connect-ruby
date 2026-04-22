# frozen_string_literal: true

RSpec.describe(K2ConnectRuby::K2Utilities::K2ProcessWebhook) do
  let(:k2_process_webhook) { K2ConnectRuby::K2Utilities::K2ProcessWebhook }

  before(:context) do
    @bg_received = HashWithIndifferentAccess.new(
      "topic": "buygoods_transaction_received",
      "id": "2133dbfb-24b9-40fc-ae57-2d7559785760",
      "created_at": "2020-10-22T10:43:20+03:00",
      "event": {
        "type": "Buygoods Transaction",
        "resource": {
          "id": "458712f-gr76y-24b9-40fc-ae57-2d35785760",
          "amount": "100.0",
          "status": "Received",
          "system": "Lipa Na M-PESA",
          "currency": "KES",
          "reference": "OJM6Q1W84K",
          "till_number": "514459",
          "sender_phone_number": "+254999999999",
          "origination_time": "2020-10-22T10:43:19+03:00",
          "sender_last_name": "Doe",
          "sender_first_name": "Jane",
          "sender_middle_name": nil,
        },
      },
      "_links": {
        "self": "https://sandbox.kopokopo.com/webhook_events/2133dbfb-24b9-40fc-ae57-2d7559785760",
        "resource": "https://sandbox.kopokopo.com/financial_transaction/458712f-gr76y-24b9-40fc-ae57-2d35785760",
      },
    )


    @bg_received_daraja_payload = HashWithIndifferentAccess.new(
      "TransactionType": "Buygoods",
      "TransID": "OJM6Q1W84K",
      "TransTime": "20260501191515",
      "TransAmount": "100.0",
      "BusinessShortCode": "000000",
      "BillRefNumber": "",
      "InvoiceNumber": "",
      "OrgAccountBalance": "",
      "ThirdPartyTransId": "",
      "MSISDN": "rbFvT0GstruVPN/B68z6yWD973VhweR31G8fhM5bxo=",
      "FirstName": "Jane",
      "MiddleName": nil,
      "LastName": nil,
    )

    @b2b_received = HashWithIndifferentAccess.new(
      "topic": "b2b_transaction_received",
      "id": "bcfb7175-bc7f-46e8-9727-eb46e6f88ef1",
      "created_at": "2020-10-29T08:18:45+03:00",
      "event": {
        "type": "External Till to Till Transaction",
        "resource": {
          "id": "fbygwu7175-bc7f-46e8-9727-f88edyy",
          "amount": "313",
          "status": "Complete",
          "system": "Lipa Na Mpesa",
          "currency": "KES",
          "reference": "OJQ8USH5XK",
          "till_number": "461863",
          "sending_till": "890642",
          "origination_time": "2020-10-29T08:18:45+03:00",
        },
      },
      "_links": {
        "self": "https://sandbox.kopokopo.com/webhook_events/bcfb7175-bc7f-46e8-9727-eb46e6f88ef1",
        "resource": "https://sandbox.kopokopo.com/financial_transaction/fbygwu7175-bc7f-46e8-9727-f88edyy",
      },
    )

    @b2b_received_daraja_payload = HashWithIndifferentAccess.new(
      "TransactionType": "Organization To Organization Transfer",
      "TransID": "OJM6Q1W84K",
      "TransTime": "20260501191515",
      "TransAmount": "100.0",
      "BusinessShortCode": "000000",
      "BillRefNumber": "",
      "InvoiceNumber": "",
      "OrgAccountBalance": "",
      "ThirdPartyTransId": "",
      "MSISDN": "112233",
      "FirstName": "Organization name",
      "MiddleName": nil,
      "LastName": nil,
    )

    @bg_reversal = HashWithIndifferentAccess.new(
      "topic": "buygoods_transaction_reversed",
      "id": "98adf21e-5721-476a-8643-609b4a6513a2",
      "created_at": "2020-10-29T08:06:49+03:00",
      "event": {
        "type": "Buygoods Transaction",
        "resource": {
          "id": "86345adf21e-5721-476a-8643-609b4a863",
          "amount": "233",
          "status": "Reversed",
          "system": "Lipa Na Mpesa",
          "currency": "KES",
          "reference": "OJM6Q1W84K",
          "till_number": "125476",
          "origination_time": "2020-10-29T08:06:49+03:00",
          "sender_last_name": "Doe",
          "sender_first_name": "Jane",
          "sender_middle_name": "",
          "sender_phone_number": "+254999999999",
        },
      },
      "_links": {
        "self": "https://sandbox.kopokopo.com/webhook_events/98adf21e-5721-476a-8643-609b4a6513a2",
        "resource": "https://sandbox.kopokopo.com/financial_transaction/86345adf21e-5721-476a-8643-609b4a863",
      },
    )

    @b2b_reversal = HashWithIndifferentAccess.new(
      "topic": "b2b_transaction_reversed",
      "id": "98adf21e-5721-476a-8643-609b4a6513a2",
      "created_at": "2020-10-29T08:06:49+03:00",
      "event": {
        "type": "External Till To Till Reversal Transaction",
        "resource": {
          "id": "86345adf21e-5721-476a-8643-609b4a863",
          "reference": "OJM6Q1W84K",
          "origination_time": "2020-10-29T08:06:49+03:00",
          "sending_till": "Sending till",
          "amount": "233",
          "currency": "KES",
          "till_number": "000000",
          "system": "M-PESA",
          "status": "Reversed",
        },
      },
      "_links": {
        "self": "https://sandbox.kopokopo.com/webhook_events/98adf21e-5721-476a-8643-609b4a6513a2",
        "resource": "https://sandbox.kopokopo.com/financial_transaction/86345adf21e-5721-476a-8643-609b4a863",
      },
    )

    @settlement_bank_account = HashWithIndifferentAccess.new(
      "topic": "settlement_transfer_completed",
      "id": "052b7b2a-745b-4ca1-866b-b92d4a1418c3",
      "created_at": "2021-01-27T11:00:08+03:00",
      "event": {
        "type": "Settlement Transfer",
        "resource": {
          "id": "270b7b2a-745b-6735752-b92d4a141847-5d33",
          "amount": "49452.0",
          "status": "Transferred",
          "currency": "KES",
          "destination": {
            "type": "Bank Account",
            "resource": {
              "reference": "34a273d1-fedc-4610-8ab6-a1ba4828f317",
              "account_name": "Test Account",
              "account_number": "1234",
              "bank_branch_ref": "ea2e79f7-35a1-486e-9e18-fe06589a9d7d",
              "settlement_method": "EFT",
            },
          },
          "disbursements": [
            {
              "amount": "24452.0",
              "status": "Transferred",
              "origination_time": "2021-01-27T10:57:58.623+03:00",
              "transaction_reference": nil,
            },
            {
              "amount": "25000.0",
              "status": "Transferred",
              "origination_time": "2021-01-27T10:57:58.627+03:00",
              "transaction_reference": nil,
            }
          ],
          "origination_time": "2021-01-27T10:57:58.444+03:00",
        },
      },
      "_links": {
        "self": "https://sandbox.kopokopo.com/webhook_events/052b7b2a-745b-4ca1-866b-b92d4a1418c3",
        "resource": "https://sandbox.kopokopo.com/transfer_batch/270b7b2a-745b-6735752-b92d4a141847-5d33",
      },
    )

    @customer = HashWithIndifferentAccess.new(
      "topic": "customer_created",
      "id": "f720ecf5-ff98-4ca8-a3f2-d70a65c4a02c",
      "created_at": "2020-10-29T08:49:02+03:00",
      "event": {
        "type": "Customer Created",
        "resource": {
          "last_name": "Doe",
          "first_name": "Jane",
          "middle_name": "M",
          "phone_number": "+254999999999",
        },
      },
      "_links": {
        "self": "https://sandbox.kopokopo.com/webhook_events/f720ecf5-ff98-4ca8-a3f2-d70a65c4a02c",
        "resource": "https://sandbox.kopokopo.com/mobile_money_user/8248a689-490e-4196-930a-db5fcbe58f6c",
      },
    )
  end

  describe "#process" do
    it "should raise an error if argument is empty" do
      expect { k2_process_webhook.process("", "", "") }.to(raise_error(ArgumentError))
    end

    context "Buy Goods Received" do
      it "processes successfully" do
        allow(K2ConnectRuby::K2Utilities::K2Authenticator).to(receive(:authenticate).and_return(true))
        expect { k2_process_webhook.process(@bg_received, "k2_secret_key", "signature") }.not_to(raise_error)
      end

      it "processes successfully" do
        allow(K2ConnectRuby::K2Utilities::K2Authenticator).to(receive(:authenticate).and_return(true))
        expect(k2_process_webhook.process(@bg_received, "k2_secret_key", "signature")).instance_of?(K2ConnectRuby::K2Services::Payloads::Webhooks::BuygoodsTransactionReceived)
      end
    end

    context "Buy Goods Received Daraja payload" do
      it "processes successfully" do
        allow(K2ConnectRuby::K2Utilities::K2Authenticator).to(receive(:authenticate).and_return(true))
        expect { k2_process_webhook.process(@bg_received_daraja_payload, "k2_secret_key", "signature") }.not_to(raise_error)
      end

      it "processes successfully" do
        allow(K2ConnectRuby::K2Utilities::K2Authenticator).to(receive(:authenticate).and_return(true))
        expect(k2_process_webhook.process(@bg_received_daraja_payload, "k2_secret_key", "signature")).instance_of?(K2ConnectRuby::K2Services::Payloads::DarajaWebhooks)
      end
    end

    context "B2B Transaction" do
      it "processes successfully" do
        allow(K2ConnectRuby::K2Utilities::K2Authenticator).to(receive(:authenticate).and_return(true))
        expect { k2_process_webhook.process(@b2b_received, "k2_secret_key", "signature") }.not_to(raise_error)
      end

      it "processes successfully" do
        allow(K2ConnectRuby::K2Utilities::K2Authenticator).to(receive(:authenticate).and_return(true))
        expect(k2_process_webhook.process(@b2b_received, "k2_secret_key", "signature")).instance_of?(K2ConnectRuby::K2Services::Payloads::Webhooks::B2bTransactionReceived)
      end
    end

    context "B2B Transaction Daraja payload" do
      it "processes successfully" do
        allow(K2ConnectRuby::K2Utilities::K2Authenticator).to(receive(:authenticate).and_return(true))
        expect { k2_process_webhook.process(@b2b_received_daraja_payload, "k2_secret_key", "signature") }.not_to(raise_error)
      end

      it "processes successfully" do
        allow(K2ConnectRuby::K2Utilities::K2Authenticator).to(receive(:authenticate).and_return(true))
        expect(k2_process_webhook.process(@b2b_received_daraja_payload, "k2_secret_key", "signature")).instance_of?(K2ConnectRuby::K2Services::Payloads::DarajaWebhooks)
      end
    end

    context "Buy Goods Reversed" do
      it "processes successfully" do
        allow(K2ConnectRuby::K2Utilities::K2Authenticator).to(receive(:authenticate).and_return(true))
        expect { k2_process_webhook.process(@bg_reversal, "k2_secret_key", "signature") }.not_to(raise_error)
      end

      it "processes successfully" do
        allow(K2ConnectRuby::K2Utilities::K2Authenticator).to(receive(:authenticate).and_return(true))
        expect(k2_process_webhook.process(@bg_reversal, "k2_secret_key", "signature")).instance_of?(K2ConnectRuby::K2Services::Payloads::Webhooks::BuygoodsTransactionReversed)
      end
    end

    context "B2B Reversed" do
      it "processes successfully" do
        allow(K2ConnectRuby::K2Utilities::K2Authenticator).to(receive(:authenticate).and_return(true))
        expect { k2_process_webhook.process(@b2b_reversal, "k2_secret_key", "signature") }.not_to(raise_error)
      end

      it "processes successfully" do
        allow(K2ConnectRuby::K2Utilities::K2Authenticator).to(receive(:authenticate).and_return(true))
        expect(k2_process_webhook.process(@b2b_reversal, "k2_secret_key", "signature")).instance_of?(K2ConnectRuby::K2Services::Payloads::Webhooks::B2bTransactionReversed)
      end
    end

    context "Settlement Transfer Completed merchant_bank_account" do
      it "processes successfully" do
        allow(K2ConnectRuby::K2Utilities::K2Authenticator).to(receive(:authenticate).and_return(true))
        expect { k2_process_webhook.process(@settlement_bank_account, "k2_secret_key", "signature") }.not_to(raise_error)
      end

      it "processes successfully" do
        allow(K2ConnectRuby::K2Utilities::K2Authenticator).to(receive(:authenticate).and_return(true))
        expect(k2_process_webhook.process(@settlement_bank_account, "k2_secret_key", "signature")).instance_of?(K2ConnectRuby::K2Services::Payloads::Webhooks::TransferWebhook)
      end
    end

    context "Customer Created" do
      it "processes successfully" do
        allow(K2ConnectRuby::K2Utilities::K2Authenticator).to(receive(:authenticate).and_return(true))
        expect { k2_process_webhook.process(@customer, "k2_secret_key", "signature") }.not_to(raise_error)
      end

      it "processes successfully" do
        allow(K2ConnectRuby::K2Utilities::K2Authenticator).to(receive(:authenticate).and_return(true))
        expect(k2_process_webhook.process(@customer, "k2_secret_key", "signature")).instance_of?(K2ConnectRuby::K2Services::Payloads::Webhooks::CustomerCreated)
      end
    end
  end

  describe "#process_k2_connect_payload" do
    it "should raise an error if event_type is not specified" do
      expect { k2_process_webhook.process_k2_connect_payload({ the_body: { event: nil } } ) }.to(raise_error(ArgumentError))
    end
  end

  describe "#return_hash" do
    it "returns a hash object" do
      expect(k2_process_webhook.return_obj_hash(K2ConnectRuby::K2Services::Payloads::Webhooks::BuygoodsTransactionReceived.new(@bg_received))).to(be_instance_of(HashWithIndifferentAccess))
    end
  end
end
