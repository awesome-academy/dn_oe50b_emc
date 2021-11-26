class StaticPagesController < ApplicationController
  def home
    @products = Product.sort_by_created.page(params[:page]).per(Settings.per_10)
  end
end
