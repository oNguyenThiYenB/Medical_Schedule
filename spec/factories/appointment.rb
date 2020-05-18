FactoryBot.define do
  factory :appointment do |f|
    f.status {Settings.waiting}
    f.phone_patient {Faker::PhoneNumber.subscriber_number(length: Settings.max_phone)}
    f.address_patient {Faker::Address}
    f.day {Date.today}
    f.start_time {"15:15"}
    f.end_time {"17:15"}
  end
end
