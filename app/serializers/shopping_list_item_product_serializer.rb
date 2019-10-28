class ShoppingListItemProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :price, :sku, :image
end
