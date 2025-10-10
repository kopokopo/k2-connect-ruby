# K2ConnectRuby For Rails

[![Gem](https://img.shields.io/gem/v/k2-connect-ruby?style=for-the-badge)](https://rubygems.org/gems/k2-connect-ruby)

Ruby SDK for connection to the Kopo Kopo API.
This documentation gives you the specifications for connecting your systems to the Kopo Kopo Application.
Primarily, the library provides functionality to do the following:

 - Receive Webhook notifications.
 - Receive payments from your users/customers.
 - Initiate payments to third parties.
 - Initiate transfers to your preferred accounts.
 
The library is optimized for **Rails Based Frameworks**.
Please note, all requests MUST be made over HTTPS.
Any non-secure requests are met with a redirect (HTTP 302) to the HTTPS equivalent URI.
All calls made without authentication will also fail.

## LINKS

 - [Installation](#installation)
 - [Usage](#installation)
    - [Authorization](#authorization)
    - [Webhook Subscription](#webhook-subscription)
    - [STK Push](#stk-push)
    - [Add External recipients](#add-external-recipients)
    - [Add Transfer accounts](#add-transfer-accounts)
    - [Send money](#send-money)
    - [Polling](#polling)
    - [Parsing the JSON Payload](#parsing-the-json-payload)
 - [Development](#development)
 - [Author](#author)
 - [Contributing](#contributing)
 - [License](#license)
 - [Changelog](#changelog)
 - [Code of Conduct](#code-of-conduct)

## Installation

Add this line to your application's Gemfile:

    gem 'k2-connect-ruby'

And then execute:

    $ bundle install

Or install it yourself:

    $ gem install k2-connect-ruby

## Usage

Add the require line to use the gem:

    require 'k2-connect-ruby'

To set the base_url:

```ruby
K2ConnectRuby::K2Utilities::Config::K2Config.base_url = "https://sandbox.kopokopo.com/"
```

> [!NOTE]
> The API version in use is K2 Connect v2. To use K2 Connect v2, make use of versions 3.0.0 of the SDK. 

> [!WARNING]
> The following APIs are deprecated on version 2 (v2).
> - Pay (Replaced with Send money)
> - Transfers (Replaced with Send money)
> - SMS Notifications

### Authorization

Ensure you first Register your application with the [Kopo Kopo Sandbox](https://sandbox.kopokopo.com).
Once an application is registered you will obtain your `client_id` and `client_secret` (aka client credentials), which will be used to identify your application when calling the Kopo Kopo API.

For more Information, visit our [API docs]().

In order to request for application authorization and receive an access token, we need to execute the client credentials flow, this is done so by having your application server make a HTTPS request to the Kopo Kopo authorization server, through the K2AccessToken class.

```ruby
access_token = K2ConnectRuby::K2Entity::K2Token.new('your_client_id', 'your_client_secret').request_token
```

### Webhook Subscription

##### Remember to store highly sensitive information like the client credentials, in a config file, while indicating in your .gitignore file.

Next, we formally create the webhook subscription by calling on the webhook_subscribe method.
Ensure the following arguments are passed: 
 - event type `REQUIRED`
 - url `REQUIRED`
 - scope `REQUIRED`: is `till` if event_type is a buygoods_transaction_received, buygoods_transaction_reversed, b2b_transaction_received, card_transaction_received, card_transaction_voided or card_transaction_reversed and `company` if not
 - scope reference: is `REQUIRED` if scope is till

Supported event types:
- buygoods_transaction_received
- buygoods_transaction_reversed
- b2b_transaction_received
- card_transaction_received
- card_transaction_voided
- card_transaction_reversed
- customer_created
- settlement_transfer_completed
 
Code example;

```ruby
require 'k2-connect-ruby'
access_token = K2ConnectRuby::K2Entity::K2Token.new('your_client_id', 'your_client_secret').request_token
k2subscriber = K2ConnectRuby::K2Entity::K2Subscribe.new(access_token)
your_request = {
  event_type: 'buygoods_transaction_received',
  url: callback_url,
  scope: 'till',
  scope_reference: '112233'
}
k2subscriber.webhook_subscribe(your_request)
```

 
### STK-Push
 
#### Receive Payments
 
 To receive payments from M-PESA users via STK Push we first create a K2Stk Object, passing the access_token that was created prior.
 
    k2_stk = K2ConnectRuby::K2Entity::K2Stk.new(access_token)
  
 Afterwards we send a POST request for receiving Payments by calling the following method and passing the params value received from the POST Form Request: 

    k2_stk.send_stk_request(your_input)
    
Ensure the following arguments are passed:
 - payment_channel `REQUIRED`
 - till_number `REQUIRED`: from the Online Payments Account created with Kopo Kopo Inc Web App
 - first_name 
 - last_name 
 - phone_number `REQUIRED`
 - email
 - currency: default is `KES`
 - value `REQUIRED`
 - callback_url `REQUIRED`

A Successful Response will be received containing the URL of the Payment Location.

#### Query Request Status

 To Query the STK Payment Request Status pass the Payment location URL response that is returned:

    k2_stk.query_resource(k2_stk.location_url)

 To Query the most recent STK Request Status is as follows:

    k2_stk.query_status

As a result a JSON payload will be returned, accessible with the k2_response_body variable.
 
Code example;
    
```ruby
k2_stk = K2ConnectRuby::K2Entity::K2Stk.new(access_token)

your_request = {
  payment_channel: "M-PESA STK Push",
  till_number: "K112233",
  first_name: "First",
  middle_name: "Middle",
  last_name: "Last",
  phone_number: "phone_number",
  email: "test_email@email.com",
  currency: "KES",
  amount: "100",
  metadata: {
    customer_id: "123_456_789",
    reference: "123_456",
    notes: "Placeholder text",
  },
  callback_url: callback_url,
}
k2_stk.send_stk_request(your_request)
k2_stk.query_resource(k2_stk.location_url)
```

### Add External Recipients

First Create the `ExternalRecipient` Object passing the access token

    external_recipient = K2ConnectRuby::K2Entity::ExternalRecipient.new(access_token)

Add a external recipient, with the following arguments:

**Mobile** External Recipient
- type: 'mobile_wallet' `REQUIRED`
- first_name `REQUIRED`
- last_name `REQUIRED`
- phone_number `REQUIRED`
- email `REQUIRED`
- network `REQUIRED`

**Bank** External Recipient
- type: 'bank_account' `REQUIRED`
- account_name `REQUIRED`
- account_number `REQUIRED`
- bank_branch_ref `REQUIRED`

**Paybill** External Recipient
- type: 'paybill' `REQUIRED`
- paybill_name `REQUIRED`
- paybill_number `REQUIRED`
- paybill_account_number `REQUIRED`

**Till** External Recipient
- type: 'till' `REQUIRED`
- till_name `REQUIRED`
- till_number `REQUIRED`

```ruby
external_recipient = K2ConnectRuby::K2Entity::ExternalRecipient.new(access_token)
your_input = {
  type: "mobile_wallet",
  first_name: "First",
  last_name: "Last",
  email: "test_email@email.com",
  phone_number: "phone_number",
}
external_recipient.add_external_recipient(your_input)
```

The type value can be `mobile_wallet`, `bank_account`, `till` or `paybill`

A Successful Response is returned with the URL of the recipient resource.

#### Query add ExternalRecipient Request Status

To Query the status of the Add Recipient:

    external_recipient.query_resource(external_recipient.recipients_location_url)

To Query the most recent status of the Add Recipient:

    external_recipient.query_status

A HTTP Response will be returned in a JSON Payload, accessible with the k2_response_body variable.

Code example;

```ruby
external_recipient = K2ConnectRuby::K2Entity::ExternalRecipient.new(access_token)
external_recipient.add_external_recipient(your_input)
external_recipient.query_resource(external_recipient.recipients_location_url)
```

### Add Transfer Accounts

Add pre-approved transfer accounts, to which one can transfer funds to. Can be either a bank or mobile wallet account,
with the following details:

**Mobile** Transfer Account
- type: 'merchant_wallet' `REQUIRED`
- first_name `REQUIRED`
- last_name `REQUIRED`
- phone_number `REQUIRED`
- network: 'Safaricom' `REQUIRED`
- nickname
- email

**Bank** Transfer Account
- type: 'merchant_bank_account' `REQUIRED`
- account_name `REQUIRED`
- account_number `REQUIRED`
- bank_branch_ref `REQUIRED`
- settlement_method: 'EFT' or 'RTS' `REQUIRED`
- nickname

```ruby
transfer_account = K2ConnectRuby::K2Entity::TransferAccount.new(access_token)
# Add a mobile merchant wallet
merchant_wallet_params = {
  type: "merchant_wallet",
  first_name: "first_name",
  last_name: "last_name",
  email: "email@email.com",
  phone_number: "phone_number",
  nickname: "nickname",
}
transfer_account.add_transfer_account(merchant_wallet_params)
# Add a merchant bank account
merchant_bank_account_params = {
  type: "merchant_bank_account",
  account_name: Faker::Name.name_with_middle,
  account_number: Faker::Number.number(digits: 10),
  bank_branch_ref: "reference to bank branch", # View https://developers.kopokopo.com/ on how to retrieve the bank branch reference
  settlement_method: "EFT",
  nickname: Faker::Name.name_with_middle,
}
transfer_account.add_transfer_account(merchant_bank_account_params)
```

A Successful Response is returned with the URL of the resource.

#### Query add transfer account Request Status

To Query the status of the Add Transfer account:

    transfer_account.query_resource(transfer_account.transfer_account_location_url)

To Query the most recent status of the Add Transfer account:

    transfer_account.query_status

A HTTP Response will be returned in a JSON Payload, accessible with the k2_response_body variable.

Code example;

```ruby
transfer_account = K2ConnectRuby::K2Entity::TransferAccount.new(access_token)
transfer_account.add_transfer_account(your_input)
transfer_account.query_resource(transfer_account.transfer_account_location_url)
```

### Send money

First Create the `SendMoney` Object passing the access token

    send_money = K2ConnectRuby::K2Entity::SendMoney.new(access_token)

Creating an Outgoing Payment to a third party.

    send_money.create_payment(your_input)
    
The following arguments should be passed within a hash:

- destinations (array of hashes) `REQUIRED`
- currency default is `KES`
- source_identifier
- callback_url `REQUIRED`

The hash structure within the destinations array:

Send to **External Mobile Recipient**
- type: 'mobile_wallet' `REQUIRED`
- phone_number `REQUIRED`
- amount `REQUIRED`
- description `REQUIRED`
- network `REQUIRED`
- first_name
- last_name
- nickname

Send to **External Bank account Recipient**
- type: 'bank_account' `REQUIRED`
- account_name `REQUIRED`
- account_number `REQUIRED`
- amount `REQUIRED`
- description `REQUIRED`
- bank_branch_ref `REQUIRED`
- nickname

Send to **External Paybill Recipient**
- type: 'paybill' `REQUIRED`
- paybill_number `REQUIRED`
- paybill_account_number `REQUIRED`
- paybill_name
- description `REQUIRED`
- nickname

Send to **External Till Recipient**
- type: 'till' `REQUIRED`
- till_number `REQUIRED`
- till_name
- description `REQUIRED`
- nickname

Send to **My Mobile Phone**
- type: 'merchant_wallet' `REQUIRED`
- reference `REQUIRED`
- amount `REQUIRED`

Send to **My Bank account**
- type: 'merchant_bank_account' `REQUIRED`
- reference `REQUIRED`
- amount `REQUIRED`

A Successful Response is returned with the URL of the Payment resource in the HTTP Location Header.

#### Query SendMoney Request Status

To Query the status of the Outgoing Payment request:

    send_money.query_resource(send_money.payments_location_url)

To Query the most recent status of Outgoing Payment request:
 
    send_money.query_status

A HTTP Response will be returned in a JSON Payload, accessible with the k2_response_body variable.
 
Code example of send money to an external recipient;

```ruby
# Send money to external recipient
params = {
  destinations: [
    {
      type: "bank_account",
      bank_branch_ref: "reference to bank branch", # View https://developers.kopokopo.com/ on how to retrieve the bank branch reference
      account_name: Faker::Name.name,
      account_number: "bank account number",
      nickname: Faker::Name.name,
      amount: "1000",
      description: "send money via K2 Connect",
    },
  ],
  currency: "KES",
  source_identifier: nil,
  callback_url: Faker::Internet.url,
}
access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
send_money = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
send_money.create_payment(params)
```

Code example of send money to a transfer account;

```ruby
# Send money to a transfer account
params = {
  destinations: [
    {
      type: "merchant_wallet",
      destination_reference: destination_reference, # Retrieved from logging into the merchant app https://app.kopokopo.com
      amount: "1000",
    },
  ],
  currency: "KES",
  source_identifier: nil,
  callback_url: callback_url,
}
access_token = K2ConnectRuby::K2Entity::K2Token.new("client_id", "client_secret").request_token
send_money = K2ConnectRuby::K2Entity::SendMoney.new(access_token)
send_money.create_payment(params)
```

### Polling

Allows you to poll transactions received on the Kopo Kopo system within a certain time range, and either for a company or a specific till.

First Create the K2Polling Object

    k2_polling = K2ConnectRuby::K2Entity::K2Polling.new(access_token)

The following details should be passed:

- scope `REQUIRED`
- scope_reference is `REQUIRED` if scope is till
- from_time `REQUIRED`
- to_time `REQUIRED`
- callback_url `REQUIRED`

Sample code example:

```ruby
your_input = {
  scope: "company",
  scope_reference: "",
  from_time: "2025-04-12T08:50:22+03:00",
  to_time: "2025-04-19T08:50:22+03:00",
  callback_url: 'http://placeholder_url_com'
}

k2_polling = K2ConnectRuby::K2Entity::K2Polling.new("access_token")
k2_polling.poll(your_input)
k2_polling.location_url # => "https://sandbox.kopokopo.com/api/v1/polling/247b1bd8-f5a0-4b71-a898-f62f67b8ae1c"
```

#### Query Request

To Query the status of the prior initiated Polling Request pass the location_url response as shown:

     k2_polling.query_resource_url(k2_polling.location_url)  

To Query the most recent initiated Polling Request:

     k2_polling.query_resource  

A HTTP Response will be returned in a JSON Payload, accessible with the k2_response_body variable.

### Parsing the JSON Payload

The K2Client class will be use to parse the Payload received from Kopo Kopo, and to further consume the webhooks and split the responses into components, the K2Authenticator and
K2ProcessResult Classes will be used.

###### K2Client Object

First Create an Object of the K2Client class to Parse the response, passing the client_secret_key received from Kopo Kopo:

     k2_parse = K2ConnectRuby::K2Services::K2Client.new(client_secret)

###### Parse the request

     k2_parse.parse_request(request)

###### Create an Object 

Create an Object to receive the components resulting from processing the parsed request results which will be returned by the following method:

     k2_components = K2ConnectRuby::K2Utilities::K2ProcessResult.process(k2_parse.hash_body, API_KEY, k2_parse.k2_signature)

or the parsed webhook results which will be returned by the following method:

     k2_components = K2ConnectRuby::K2Utilities::K2ProcessWebhook.process(k2_parse.hash_body, API_KEY, k2_parse.k2_signature)
     
Code example:

```ruby
k2_parse = K2ConnectRuby::K2Services::K2Client.new(API_KEY)
k2_parse.parse_request(request)
k2_components = K2ConnectRuby::K2Utilities::K2ProcessResult.process(k2_parse.hash_body, API_KEY, k2_parse.k2_signature)
```
         
 Below is a list of key symbols accessible for each of the Results retrieved after processing it into an Object.
 
1. Buy Goods Transaction Received:
    - `id`
    - `resource_id`
    - `topic`
    - `created_at`
    - `event_type`
    - `reference`
    - `origination_time`
    - `sender_phone_number`
    - `amount`
    - `currency`
    - `till_number`
    - `system`
    - `status`
    - `sender_first_name`
    - `sender_last_name`
    - `links_self`
    - `links_resource`
    
2. Buy Goods Transaction Reversed:
    - `id`
    - `resource_id`
    - `topic`
    - `created_at`
    - `event_type`
    - `reference`
    - `origination_time`
    - `sender_phone_number`
    - `amount`
    - `currency`
    - `till_number`
    - `system`
    - `status`
    - `sender_first_name`
    - `sender_last_name`
    - `links_self`
    - `links_resource` 
    
3. Settlement Transfer:
    - `id`
    - `resource_id`
    - `topic`
    - `created_at`
    - `event_type`
    - `origination_time`
    - `amount`
    - `currency`
    - `resource_status`
    - `links_self`
    - `links_resource`
    - `destination_reference`
    - `destination_type`
      **Bank Account** Destination Type
    - `destination_account_name`
    - `destination_account_number`
    - `destination_bank_branch_ref`
    - `destination_settlement_method`
      **Merchant Wallet** Destination Type
    - `destination_first_name`
    - `destination_last_name`
    - `destination_phone_number`
    - `destination_network`

4. Customer Created:
    - `id`
    - `resource_id`
    - `topic`
    - `created_at`
    - `event_type`
    - `resource_first_name`
    - `resource_middle_name`
    - `resource_last_name`
    - `resource_phone_number`
    - `links_self`
    - `links_resource`
    
5. B2b Transaction Received (External Till to Till):
    - `id`
    - `resource_id`
    - `topic`
    - `created_at`
    - `event_type`
    - `reference`
    - `origination_time`
    - `amount`
    - `currency`
    - `till_number`
    - `status`
    - `links_self`
    - `links_resource`
    - `sending_till`

6. Card Transaction Received
    - `id`
    - `resource_id`
    - `topic`
    - `created_at`
    - `event`
    - `reference`
    - `origination_time`
    - `amount`
    - `currency`
    - `till_number`
    - `customer_cc_number`
    - `status`
    - `links_self`
    - `links_resource`
    - `settled`

7. Card Transaction Reversed:
    - `id`
    - `resource_id`
    - `topic`
    - `created_at`
    - `event`
    - `reference`
    - `origination_time`
    - `amount`
    - `currency`
    - `till_number`
    - `customer_cc_number`
    - `status`
    - `links_self`
    - `links_resource`

8. Card Transaction Voided (External Till to Till):
    - `id`
    - `resource_id`
    - `topic`
    - `created_at`
    - `event_type`
    - `reference`
    - `origination_time`
    - `amount`
    - `currency`
    - `till_number`
    - `customer_cc_number`
    - `status`
    - `links_self`
    - `links_resource`
    
9. Process STK Push Payment Request Result
    - `id`
    - `type`
    - `initiation_time`
    - `status`
    - `event_type`
    - `resource_id`
    - `resource_status`
    - `transaction_reference`
    - `origination_time`
    - `sender_phone_number`
    - `amount`
    - `currency`
    - `till_number`
    - `system`
    - `sender_first_name`
    - `sender_middle_name`
    - `sender_last_name`
    - `errors`
    - `metadata`
    - `links_self`
    - `callback_url`

10. Process Send money Result
    - `id`
    - `type`
    - `created_at`
    - `status`
    - `transfer_batch`
    - `currency`
    - `value`
    - `metadata`
    - `links_self`
    - `callback_url`
    
If you want to convert the Object into a Hash or Array, the following methods can be used.
- Hash:
   
   
        k2_hash_components = K2ConnectRuby::K2Utilities::K2ProcessResult.return_obj_hash(k2_components)
    
    
- Array:
   
    
        k2_array_components = K2ConnectRuby::K2Utilities::K2ProcessResult.return_obj_array(k2_components)


Sample Web Application examples written in Rails and Sinatra frameworks that utilize this library are available in the example_app folder or in the following GitHub hyperlinks:

 - [Rails example application](https://github.com/DavidKar1uk1/kt_tips_rails)

 - [Sinatra example application](https://github.com/DavidKar1uk1/kt_tips)
 
 ##### Take Note; the Library is optimized for Rails frameworks version 5.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Author

**Name**:   [David Kariuki Mwangi](https://github.com/DavidJonKariz)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kopokopo/k2-connect-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License].

## Changelog



## Code of Conduct

Everyone interacting in the K2ConnectRuby project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/kopokopo/k2-connect-ruby/blob/master/CODE_OF_CONDUCT.md).
