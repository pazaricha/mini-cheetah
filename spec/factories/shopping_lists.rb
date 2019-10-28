FactoryBot.define do
  factory :shopping_list do
    name { Faker::DcComics.name }
    user
  end
end
