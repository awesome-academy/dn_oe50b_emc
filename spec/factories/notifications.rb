FactoryBot.define do
  factory :notification do
    sender_id { "" }
    content { "MyString" }
    receiver_id { "" }
  end
end
