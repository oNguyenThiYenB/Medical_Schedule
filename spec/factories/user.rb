FactoryBot.define do
  factory :user do
    user_name { Faker::Name.name }
    full_name { Faker::Name.name }
    email { Faker::Internet.email }
    password_digest {BCrypt::Password.create(Settings.default_password)}
    after(:build) do |user|
      user.image.attach io: File.open(Rails.root
        .join("app", "assets", "images", "default_avatar.png")),
        filename: "default_avatar.png"
    end
  end
end
