FactoryBot.define do
  factory :product do
    name { Faker::Food.ingredient }
    barcode { SecureRandom.hex(4) }
    price_cents { 100 }
    sku { SecureRandom.uuid }
  end
end
