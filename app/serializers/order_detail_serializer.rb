class OrderDetailSerializer < ActiveModel::Serializer
  attributes :id, :price, :quantity
  belongs_to :product
  belongs_to :order

  def product
    {
      id: object.product.id,
      name: object.product.name
    }
  end

  def order
    {
      id: object.order.id,
      name: object.order.name_customer
    }
  end
end
