# frozen_string_literal: true

class CheckoutsController < ApplicationController
  before_action :initialize_cart
  before_action :authenticate_customer_user!

  def new
    @customer = current_customer_user
    if @customer
      @customer.name ||= @customer.name
      @customer.address ||= @customer.address
      @customer.phone_number ||= @customer.phone_number
      @customer.province_id ||= @customer.province_id
    end
    @cart_items = session[:cart] || {}
    @products = Product.where(id: @cart_items.keys)
    @provinces = Province.all

    @order = Order.new(
      customer_user_id: current_customer_user.id,
      total_price: calculate_total_price(current_customer_user.province_id)
    )
  end

  def create
    Rails.logger.info "Current Customer User: #{current_customer_user.inspect}"

    ActiveRecord::Base.transaction do
      order = Order.create!(
        customer_user_id: current_customer_user.id,
        total_price: calculate_total_price(current_customer_user.province_id)
      )

      product_ids = session[:cart].keys
      products = Product.where(id: product_ids)

      products.each do |product|
        quantity = session[:cart][product.id.to_s].to_i
        order.order_items.create!(
          product:,
          quantity:,
          price: product.price
        )
      end

      session[:cart] = {}

      redirect_to order_path(order)
    end
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound => e
    flash.now[:alert] = "There was an error processing your order: #{e.message}"
    render :new
  end

  def fetch_tax_rates
    province = Province.find_by(id: params[:province_id])
    if province
      render json: {
        gst: province.gst,
        pst: province.pst,
        hst: province.hst
      }
    else
      render json: { error: 'Province not found' }, status: :not_found
    end
  end

  private

  def customer_params
    params.require(:customer_user).permit(:name, :address, :phone_number, :province_id)
  end

  def calculate_total_price(province_id)
    subtotal = session[:cart].sum do |product_id, quantity|
      product = Product.find(product_id)
      product.price * quantity
    end

    province = Province.find(province_id)
    taxes = subtotal * (province.pst + province.gst + province.hst)
    subtotal + taxes
  end

  def set_tax_rates(province_id)
    province = Province.find_by(id: province_id)
    @gst = province&.gst || 0
    @pst = province&.pst || 0
    @hst = province&.hst || 0
  end

  def initialize_cart
    session[:cart] ||= {}
  end
end
