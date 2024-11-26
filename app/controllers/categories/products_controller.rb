module Categories
  class ProductsController < ApplicationController
    def index
      @category = Category.find(params[:category_id])
      @products = @category.products.includes(images_attachments: :blob).page(params[:page]).per(10)
    end
  end
end
