class Product < ApplicationRecord
  has_many :rates, dependent: :destroy
  has_many :order_details, dependent: :destroy
  enum statuses: {Hot: 0, New: 1, Trend: 2}
  belongs_to :category, foreign_key: "categories_id"
  delegate :title, to: :category, prefix: true
  has_one_attached :image
  validates :name, presence: true, length: {minimum: Settings.atrr.lenght_min,
                                            message: :min_8}
  validates :price, presence: true, numericality: {greater_than_or_equal_to:
                                                  Settings.atrr.price_min}
  validates :quantity, presence: true, numericality: {greater_than_or_equal_to:
                                                     Settings.atrr.quantity_min}
  validates :author, presence: true
  validates :publisher, presence: true
  validates :image, content_type: {in: %w(image/jpeg image/gif image/png),
                                   message: I18n.t("image.invalid")},
                    size: {less_than: 5.megabytes, message: I18n.t("image.min")}
  scope :ordered_by_price, ->{order(price: :asc)}
  scope :sort_by_created, ->{order(created_at: :desc)}
end
