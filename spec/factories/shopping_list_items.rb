FactoryBot.define do
  factory :shopping_list_item do
    shopping_list
    product
    quantity { rand(1..100) }
  end
end
