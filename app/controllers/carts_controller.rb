class CartsController < ApplicationController
  before_action :find_product, :get_line_item,
                only: [:add_to_cart, :update, :delete]
  before_action :get_quantity_for_add, only: [:add_to_cart]
  before_action :check_enought_quantity?,
                only: [:add_to_cart, :update]

  def index
    @cart_items = get_line_items_in_cart
  end

  def add_to_cart
    if @item
      @item["quantity"] += params[:quantity].to_i
      flash[:info] = t "cart.update_quantity"
    else
      current_cart << {product_id: @product.id,
                       quantity: params[:quantity].to_i}
      flash[:success] = t "cart.add_success"
    end
    session[:cart] = current_cart
    redirect_to root_path
  end

  def update
    if @item
      @item["quantity"] = params[:quantity].to_i
      flash.now[:success] = t "cart.update_quantity"
      redirect_to carts_path
    else
      flash[:danger] = t "cart.error_update"
    end
    @cart_items = get_line_items_in_cart
  end

  def delete
    if @item
      flash[:warning] = t "cart.delete_success"
      current_cart.delete(@item)
      redirect_to carts_path
    else
      flash[:danger] = t "cart.error_delete"
    end
    @cart_items = get_line_items_in_cart
  end

  private

  def check_enought_quantity?
    quantity = if @item
                 @item["quantity"] + params[:quantity].to_i
               else
                 params[:quantity].to_i
               end
    return if @product.check_enought_quantity? quantity

    flash[:danger] = t "product.out_stock"
    redirect_to root_path
  end

  def get_line_item
    @item = find_product_in_cart @product
  end

  def get_quantity_for_add
    @quantity = if @item
                  @item["quantity"] + params[:quantity].to_i
                else
                  params[:quantity].to_i
                end
  end
end
