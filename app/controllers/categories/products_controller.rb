# frozen_string_literal: true

module Categories
  class ProductsController < ApplicationController
    def index
      @category = Category.find(params[:category_id])
      @products = @category.products.includes(images_attachments: :blob).page(params[:page]).per(10)

      case params[:filter]
      when 'new'
        @products = @products.where(created_at: 3.days.ago..)
      when 'on_sale'
        @products = @products.where(on_sale: true) # 假设有 `on_sale` 字段
      when 'recently_updated'
        @products = @products.where('updated_at >= ? AND created_at < ?', 3.days.ago, 3.days.ago)
      end
    end
  end
end
