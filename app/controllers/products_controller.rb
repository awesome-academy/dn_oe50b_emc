class ProductsController < ApplicationController
  def new
    @product = Product.new
  end

  def show
    @product = Product.find_by(id: params[:id])
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:success] = t "product.create_succ"
      redirect_to action: :list
    else
      render :new
    end
  end

  def edit
    @product = Product.find_by(id: params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      flash[:success] = t "product.update_succ"
      redirect_to action: :list
    else
      flash[:error] = t "product.update_fail"
      render :edit
    end
  end

  def list
    @products = Product.all
  end

  def destroy
    @product = Product.find(params[:id])
    if @product.delete
      flash[:success] = t "product.delete_succ"
      redirect_to action: :list
    else
      flash[:danger] = t "product.delete_fail"
      render :destroy
    end
  end

  private
  def product_params
    params.require(:product).permit(:name, :price, :quantity, :status, :author,
                                    :categories_id, :publisher, :description)
  end
end
