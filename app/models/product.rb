class Product < ApplicationRecord
  has_many :rates, dependent: :destroy
  has_many :order_details, dependent: :destroy
  belongs_to :category, foreign_key: "categories_id"
  validates :name, presence: true, length: {minimum: Settings.atrr.lenght_8,
                                            message: :min_8}
  validates :price, presence: true, numericality: {greater_than_or_equal_to:
                                                  Settings.atrr.price_50}
  validates :quantity, presence: true, numericality: {greater_than_or_equal_to:
                                                      Settings.atrr.quantity_10}
  validates :author, presence: true
  validates :publisher, presence: true
end
