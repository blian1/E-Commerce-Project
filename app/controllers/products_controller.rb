# frozen_string_literal: true

class ProductsController < ApplicationController
  def index
    @products = Product.includes(images_attachments: :blob).page(params[:page]).per(10)

    # Filter the product
    case params[:filter]
    when 'new'
      @products = @products.where(created_at: 3.days.ago..)
    when 'on_sale'
      @products = @products.where(on_sale: true)
    when 'recently_updated'
      @products = @products.where('updated_at >= ? AND created_at < ?', 3.days.ago, 3.days.ago)
    end

    # search for the product
    return unless params[:query].present? || params[:category_id].present?

    if params[:query].present?
      @products = @products.where('name LIKE ? OR description LIKE ?', "%#{params[:query]}%",
                                  "%#{params[:query]}%")
    end
    @products = @products.where(category_id: params[:category_id]) if params[:category_id].present?
  end

  def show
    @product = Product.find(params[:id])
  end
end
