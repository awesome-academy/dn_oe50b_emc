FactoryBot.define do
 factory :product do
    name{Faker::Commerce.product_name}
    quantity {rand(60..50000)}
    price {rand(60..50000)}
    status {rand(0...2)}
    author {Faker::Name.name }
    publisher {Faker::Name.name }
    description {Faker::Lorem.sentence(word_count: 5)}
    category { FactoryBot.create(:category)}
  end
end
