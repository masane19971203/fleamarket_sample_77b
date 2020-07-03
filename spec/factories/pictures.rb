FactoryBot.define do
  factory :pictures do
    image{Faker::Avatar.image}
  end
end
