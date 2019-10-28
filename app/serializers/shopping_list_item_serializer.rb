class ShoppingListItemSerializer < ActiveModel::Serializer
  attributes :id, :position, :quantity, :product

  def product
    ShoppingListItemProductSerializer.new(object.product)
  end
end
