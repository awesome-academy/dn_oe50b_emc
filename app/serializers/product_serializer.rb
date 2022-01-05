class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :price, :quantity, :status, :author,
             :publisher, :description, :category
  belongs_to :category

  def category
    {
      id: object.category.id,
      name: object.category.title
    }
  end
end
