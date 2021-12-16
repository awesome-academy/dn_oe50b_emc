class Admin::StatisticsController < ApplicationController
  def index; end

  def month
    render json: Order.approved.group_by_month(:created_at).count
  end

  def quarter
    render json: Order.approved.group_by_quarter(:created_at).count
  end

  def year
    render json: Order.approved.group_by_year(:created_at).count
  end
end
