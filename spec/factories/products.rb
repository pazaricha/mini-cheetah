FactoryBot.define do
  factory :product do
    name { Faker::Food.ingredient }
    barcode { SecureRandom.hex(4) }
    price_cents { rand(100..99999) }
    sku { SecureRandom.uuid }
  end
end
