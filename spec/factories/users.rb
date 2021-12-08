FactoryBot.define do
  factory :user do
    name { "Tan Binh" }
    email { "Test@gmail.com" }
    id_card { "123456789" }
    phone_number { "0312345678" }
    address { "Quang Nam" }
    password {"binh123"}
    password_confirmation {"binh123"}
  end
end
