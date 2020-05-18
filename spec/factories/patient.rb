FactoryBot.define do
  factory :patient do
    user_name { Faker::Name.name }
    full_name { Faker::Name.name }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.phone_number }
    address { Faker::Address.street_address }
    password_digest {BCrypt::Password.create(Settings.default_password)}
  end
end
