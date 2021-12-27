class StaticPagesController < ApplicationController
  before_action :load_categories, only: %i(home filter_by_category
                                         filter_by_status)

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

  def filter_by_category
    @products = Product.by_categori(params[:id]).sort_by_created
                       .page(params[:page]).per(Settings.per_3)
    render "static_pages/home"
  end

  def filter_by_status
    @products = Product.by_status(params[:id]).sort_by_created
                       .page(params[:page]).per(Settings.per_3)
    render "static_pages/home"
  end

  private

  def load_categories
    @categories = Category.all
  end
end
