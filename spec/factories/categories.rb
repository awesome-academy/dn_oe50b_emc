FactoryBot.define do
  factory :category do
    title {Faker::Lorem.sentence(word_count: 3)}
    content {Faker::Lorem.sentence(word_count: 5)}
  end
end
