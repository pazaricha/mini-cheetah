FactoryBot.define do
  factory :producer do
    name { Faker::Company.name }
  end
end
