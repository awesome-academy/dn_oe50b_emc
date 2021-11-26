class Order < ApplicationRecord
  belongs_to :user
  has_many :order_details, dependent: :destroy
  scope :ordered_by_price, ->{order(total_money: :asc)}
end
