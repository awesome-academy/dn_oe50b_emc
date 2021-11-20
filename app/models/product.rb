class Product < ApplicationRecord
  belongs_to :category
  has_many :rates, dependent: :destroy
  has_many :order_details, dependent: :destroy
end
