class Order < ApplicationRecord
  belongs_to :user
  has_many :order_details, dependent: :destroy
  scope :ordered_by_price, ->{order(:total_money)}
  has_many :products, through: :order_details

  validates :name_customer, presence: true,
            length: {minimum: Settings.validate.length.digist_2}
  validates :address, presence: true,
            length: {minimum: Settings.validate.length.digist_6}
  validates :phone_number, presence: true,
            length: {minimum: Settings.validate.length.digist_6},
            format: {with: Settings.regex.PHONE_NUMBER_REGEX}
end
