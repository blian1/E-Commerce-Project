class CheckoutsController < ApplicationController
  before_action :initialize_cart

  def new
    @customer = current_customer_user || CustomerUser.new
    if current_customer_user
      @customer.name ||= current_customer_user.name
      @customer.address ||= current_customer_user.address
      @customer.phone_number ||= current_customer_user.phone_number
      @customer.province_id ||= current_customer_user.province_id
    end
    @cart_items = session[:cart] || {}
    @products = Product.where(id: @cart_items.keys)

    @provinces = Province.all
  end

  def create
    @customer = current_user || CustomerUser.new(customer_params)

    unless @customer.save
      @provinces = Province.all
      @cart_items = session[:cart] || {}
      @products = Product.where(id: @cart_items.keys) # 重新初始化 @products
      flash[:alert] = "Failed to save customer information."
      render :new and return
    end

    ActiveRecord::Base.transaction do
      order = @customer.orders.create!(total_price: calculate_total_price)

      product_ids = session[:cart].keys
      products = Product.where(id: product_ids)

      products.each do |product|
        quantity = session[:cart][product.id.to_s].to_i
        order.order_items.create!(
          product: product,
          quantity: quantity,
          price: product.price
        )
      end

      session[:cart] = {}

      redirect_to order_path(order), notice: "Order successfully placed!"
    end
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound => e
    @provinces = Province.all
    @cart_items = session[:cart] || {}
    @products = Product.where(id: @cart_items.keys)
    flash[:alert] = "There was an error processing your order: #{e.message}"
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
      render json: { error: "Province not found" }, status: :not_found
    end
  end


  private

  def customer_params
    params.require(:customer_user).permit(:name, :address, :phone_number, :province_id)
  end

  def calculate_total_price
    subtotal = session[:cart].sum do |product_id, quantity|
      product = Product.find(product_id)
      product.price * quantity
    end

    province = Province.find(current_user.province_id)
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
