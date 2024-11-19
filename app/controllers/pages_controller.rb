class PagesController < ApplicationController
  def show
    @page = Page.find_by(title: params[:title])
    if @page
      render :show
    else
      render plain: "Page not found", status: 404
    end
  end
end
