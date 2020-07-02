FactoryBot.define do
  factory :product do
    
    name{Faker::Food.ingredient}
    text{}
    price{Faker::Number.between(from: 300, to: 9999999)}
    brand{Faker::Company.name}
    category_id {Faker::Number.between(from: 1, to: 1000)}
    size_id{Faker::Number.between(from: 1, to: 3)}
    status_id{Faker::Number.between(from: 1, to: 6)}
    postage_id{Faker::Number.between(from: 1, to:2)}
    area_id{Faker::Number.between(from: 1, to:47)}
    shipping_date_id{Faker::Number.between(from: 1, to:3)}
    purchase{"false"}
    user_id{Faker::Number.between(from: 1, to: 100)}

  end
end
