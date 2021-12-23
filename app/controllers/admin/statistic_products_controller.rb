class Admin::StatisticProductsController < ApplicationController
  def index; end

  def chart_by_period
    case params[:period]
    when Settings.period.month
      render json: Product.group_by_month(:created_at).size
    when Settings.period.quarter
      render json: Product.group_by_quarter(:created_at).size
    when Settings.period.year
      render json: Product.group_by_year(:created_at).size
    end
  end
end
