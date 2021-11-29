class ApplicationController < ActionController::Base
  before_action :set_locale

  protect_from_forgery with: :exception
  include SessionsHelper

  private
  def set_locale
    I18n.locale = params[:locale] if params[:locale].present?
  end

  def default_url_options
    {locale: I18n.locale}
  end
end
