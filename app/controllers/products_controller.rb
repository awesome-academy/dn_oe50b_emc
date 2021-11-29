class ProductsController < ApplicationController
  def index
    @products = Product.ordered_by_price
                       .page(params[:page]).per(Settings.atrr.paging_min)
  end
end
