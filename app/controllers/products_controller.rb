class ProductsController < ApplicationController
  def index
    @products = Product.includes(images_attachments: :blob).page(params[:page]).per(10)
  end
end
