class OrderSerializer < ActiveModel::Serializer
  attributes :id, :total_money, :status, :name_customer, :user
  belongs_to :user
  has_many :order_details
  def user
    {
      email: object.user.email,
      name: object.user.name
    }
  end
end
