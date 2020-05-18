FactoryBot.define do
  factory :doctor do |f|
    f.user_name {Faker::Name.name}
    f.full_name {Faker::Name.name}
    f.email {Faker::Internet.email}
    f.department {"Neurosurgery"}
    f.position {"Doctor"}
    f.password {"111111"}
    f.password_confirmation {"111111"}
    f.room {302}
  end
end
