class ShoppingListSerializer < ActiveModel::Serializer
  attributes :id, :name, :items

  def items
    object.items.page(@instance_options[:page]).includes(:product).ordered_by_position.map do |item|
      ShoppingListItemSerializer.new(item)
    end
  end
end
