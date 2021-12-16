class ApplicationController < ActionController::Base
  USER_ATTRS = %w(name email id_card phone_number address password
                  current_password).freeze

  before_action :set_locale

  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  include SessionsHelper
  include CartHelper

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit USER_ATTRS
    end
  end

  private
  def set_locale
    I18n.locale = params[:locale] if params[:locale].present?
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def find_product
    @product = Product.find_by(id: params[:id])
    return if @product

    flash[:danger] = t "product.not_found"
    redirect_to root_path
  end
end
