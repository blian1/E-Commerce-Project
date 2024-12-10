require "paypal-checkout-sdk"

module PayPalClient
  class << self
    def client
      PayPal::PayPalHttpClient.new(environment)
    end

    def environment
      PayPal::SandboxEnvironment.new(
        Rails.application.credentials.paypal[:client_id],
        Rails.application.credentials.paypal[:client_secret]
      )
    end
  end
end
