class ProductsController < ApplicationController
  def index
    @products = Product.ordered_by_price
                       .page(params[:page]).per(Settings.atrr.paging_min)
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:success] = t "flash.create_succ"
      redirect_to action: :index
    else
      render :new
    end
  end

  private
  def product_params
    params.require(:product).permit(:name, :price, :quantity, :status, :author,
                                    :categories_id, :publisher, :description,
                                    :image)
  end
end
