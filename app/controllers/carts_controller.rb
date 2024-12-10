# frozen_string_literal: true

class CartsController < ApplicationController
  before_action :initialize_cart

  def show
    @cart_items = session[:cart] || {}
    product_ids = @cart_items.keys
    @products = Product.where(id: product_ids)
    flash.now[:alert] = 'No products found in the cart.' if @products.blank?
  end

  def add_to_cart
    product_id = params[:product_id]
    quantity = params[:quantity].to_i

    if quantity <= 0
      redirect_to cart_path, alert: 'Quantity must be greater than zero!'
      return
    end

    product = Product.find_by(id: product_id)
    unless product
      redirect_to cart_path, alert: 'Product not found!'
      return
    end

    session[:cart][product_id] = session[:cart][product_id].to_i + quantity
    redirect_to cart_path, notice: 'Product added to cart!'
  end

  def remove_item
    product_id = params[:product_id]

    if session[:cart] && session[:cart][product_id]
      session[:cart].delete(product_id)
      flash[:notice] = 'Product removed from cart.'
    else
      flash[:alert] = 'Product not found in cart.'
    end

    redirect_to cart_path
  end

  private

  def initialize_cart
    session[:cart] ||= {}
  end
end
