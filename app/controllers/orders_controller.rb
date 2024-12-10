# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :set_order, only: [:show]

  def show
    @order = Order.find(params[:id])
    @subtotal = @order.order_items.sum { |item| item.price * item.quantity }

    province = Province.find(@order.customer_user.province_id)
    @gst = (@subtotal * province.gst).round(2)
    @pst = (@subtotal * province.pst).round(2)
    @hst = (@subtotal * province.hst).round(2)
    @total_price = (@subtotal + @gst + @pst + @hst).round(2)
    @order_items = @order.order_items.includes(:product)
  end

  private

  def set_order
    @order = Order.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'Order not found.'
  end
end
