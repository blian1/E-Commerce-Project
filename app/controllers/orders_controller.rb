class OrdersController < ApplicationController
  before_action :set_order, only: [ :show ]

  def show
    unless @order.customer == current_user
      redirect_to root_path, alert: "You are not authorized to view this order."
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Order not found."
  end
end
