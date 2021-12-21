class StaticPagesController < ApplicationController
  def home
    @products = @q.result(distinct: true).sort_by_created
                  .page(params[:page]).per(Settings.per_3)
  end

  def show
    @products = Product.find_by(id: params[:id])
    return if @products

    flash[:warning] = t "flash.product_not_found"
    redirect_to home_client_path
  end
end
