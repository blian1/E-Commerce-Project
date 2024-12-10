class PaymentsController < ApplicationController
  def create
    begin
      order = Order.find(params[:order_id])
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error "Order not found: #{e.message}"
      render json: { error: "Order not found. Please try again." }, status: :not_found
      return
    end

    request = PayPalCheckoutSdk::Orders::OrdersCreateRequest.new
    request.request_body(
      {
        intent: "CAPTURE",
        purchase_units: [
          {
            amount: {
              currency_code: "CAD",
              value: order.total_price.to_s
            }
          }
        ],
        application_context: {
          return_url: success_order_payments_url(order_id: order.id),
          cancel_url: cancel_order_payments_url(order_id: order.id),
          user_action: "PAY_NOW"
        }
      }
    )

    begin
      response = PayPalClient.client.execute(request)
      Rails.logger.info "PayPal response: #{response.result.inspect}"

      if response.status_code == 201
        paypal_order_id = response.result.id
        order.update!(status: "unpaid", paypal_order_id: paypal_order_id)

        render json: { paypal_order_id: paypal_order_id, links: response.result.links }, status: :ok
      else
        Rails.logger.error "PayPal API error. Status: #{response.status_code}"
        render json: { error: "Failed to create PayPal payment. Please try again." }, status: :unprocessable_entity
      end
    rescue PayPalHttp::HttpError => e
      Rails.logger.error "PayPalHttp::HttpError: #{e.message}"
      Rails.logger.error "Request body: #{request.request_body.inspect}"
      render json: { error: "PayPal API error. Please contact support." }, status: :internal_server_error
    rescue => e
      Rails.logger.error "Unexpected error encountered: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      render json: { error: "An unexpected error occurred. Please try again." }, status: :internal_server_error
    end
  end

  def success
    begin
      order = Order.find(params[:order_id])
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error "Order not found: #{e.message}"
      redirect_to root_path, alert: "Order not found. Please try again."
      return
    end

    paypal_order_id = order.paypal_order_id
    request = PayPalCheckoutSdk::Orders::OrdersGetRequest.new(paypal_order_id)

    begin
      response = PayPalClient.client.execute(request)
      Rails.logger.info "PayPal order details: #{response.result.inspect}"

      if response.result.status == "APPROVED"
        capture_request = PayPalCheckoutSdk::Orders::OrdersCaptureRequest.new(paypal_order_id)
        capture_response = PayPalClient.client.execute(capture_request)

        if capture_response.result.status == "COMPLETED"
          order.update!(status: "paid")
          redirect_to root_path, notice: "Payment was successful!"
        else
          Rails.logger.error "Payment capture failed. Status: #{capture_response.result.status}"
          redirect_to root_path, alert: "Payment not completed. Please contact support."
        end
      else
        Rails.logger.error "PayPal order not completed. Status: #{response.result.status}"
        redirect_to root_path, alert: "Payment not completed. Please contact support."
      end
    rescue PayPalHttp::HttpError => e
      Rails.logger.error "PayPalHttp::HttpError: #{e.message}"
      redirect_to root_path, alert: "Error validating PayPal order. Please try again."
    end
  end



  def cancel
    begin
      order = Order.find(params[:order_id])
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error "Order not found: #{e.message}"
      redirect_to root_path, alert: "Order not found. Please try again."
      return
    end

    Rails.logger.info "Payment canceled for Order##{order.id}."

    redirect_to root_path, alert: "Payment was canceled."
  end
end
