# frozen_string_literal: true

module PayPalClient
  CLIENT_ID = 'Ae1cBTjHZtNNcfE7t-M2ifkUl9IAd1_hP48nrgi1hn9ogDRbWdfP8nCZZIuuGl7Vnd0tJBFLU_GSrrZg'
  CLIENT_SECRET = 'EN_trQW3fn78MPXMLPft_tmNRF_ctTno1gFvNt1W3KXuE83gJ62stGg1PLVrqwrZPUQXJDt0VrgnGdJL'
  class << self
    def environment
      PayPal::SandboxEnvironment.new(CLIENT_ID, CLIENT_SECRET)
    end

    def client
      PayPal::PayPalHttpClient.new(environment)
    end
  end
end
