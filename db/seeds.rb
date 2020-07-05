Faculty.delete_all
User.delete_all
DoctorFaculty.delete_all
ShiftWork.delete_all
Appointment.delete_all
Comment.delete_all
ArticleCategory.delete_all
Article.delete_all


d = Faculty.create!(id: 1, faculty_name: "Ngoại Tiêu hoá")
d.save

d = Faculty.create!(id: 2, faculty_name: "Ngoại Tiết niệu")
d.save

d = Faculty.create!(id: 3, faculty_name: "Ngoại Chấn thương")
d.save

d = Faculty.create!(id: 4, faculty_name: "Ngoại Phẫu thuật thần kinh cột sống")
d.save

d = Faculty.create!(id: 5, faculty_name: "Ngoại Tạo hình thẩm mỹ")
d.save

d = Doctor.create!(id: 1, user_name: "yennguyen",
  full_name: "Nguyễn Thị Yên",
  email: "yennguyen26101998@gmail.com",
  department: "Phẫu thuật thần kinh",
  position: "Bác sỹ",
  password: "111111",
  password_confirmation: "111111",
  room: 301,
  confirmed_at: Time.zone.now)
d.image.attach io: File.open(Rails.root
  .join("app", "assets", "images", "default_doctor.jpg")),
  filename: "default_doctor.jpg"
d.save

20.times do |n|
  d = Doctor.create!(id: n+2, user_name: Faker::Name.name,
    full_name: Faker::Name.name,
    email: "example-#{n+1}@railstutorial.org",
    department: "Phẫu thuật thần kinh",
    position: "Bác sỹ",
    password: "111111",
    password_confirmation: "111111",
    room: 302,
    confirmed_at: Time.zone.now)
  d.image.attach io: File.open(Rails.root
    .join("app", "assets", "images", "default_doctor.jpg")),
    filename: "default_doctor.jpg"
  d.save
end

d = DoctorFaculty.create!(doctor_id: 1,
  faculty_id: 1)
d.save

d = DoctorFaculty.create!(doctor_id: 1,
  faculty_id: 3)
d.save

d = DoctorFaculty.create!(doctor_id: 2,
  faculty_id: 1)
d.save

10.times do |n|
  d = DoctorFaculty.create!(doctor_id: n+2,
    faculty_id: 1)
  d.save
end

8.times do |n|
  p = Patient.create!(id: 22+n, user_name: Faker::Name.name,
    full_name: Faker::Name.name,
    email: "email#{n}@gmail.com",
    password: "111111",
    password_confirmation: "111111",
    confirmed_at: Time.zone.now)
  p.image.attach io: File.open(Rails.root
    .join("app", "assets", "images", "default_avatar.png")),
    filename: "default_avatar.png"
  p.save
end

10.times do |n|
  p = Staff.create!(id: 30+n, user_name: Faker::Name.name,
    full_name: Faker::Name.name,
    email: "staff#{n}@gmail.com",
    password: "111111",
    password_confirmation: "111111",
    confirmed_at: Time.zone.now)
  p.image.attach io: File.open(Rails.root
    .join("app", "assets", "images", "default_avatar.png")),
    filename: "default_avatar.png"
  p.save
end

8.times do |n|
    minute = (n%2 == 0) ? ":00" : ":30"
    minute_end = (n%2 == 0) ? ":30" : ":00"
    ShiftWork.create!(
    start_time: Time.zone.parse("#{7 + n/2}" + minute),
    end_time: Time.zone.parse("#{7 + (1+n)/2}" + minute_end))
end

8.times do |n|
  minute = (n%2 == 0) ? ":00" : ":30"
  minute_end = (n%2 == 0) ? ":30" : ":00"
  ShiftWork.create!(
  start_time: Time.zone.parse("#{12 + n/2}" + minute),
  end_time: Time.zone.parse("#{12 + (1+n)/2}" + minute_end))
end

8.times do |n|
  Appointment.create!(shift_work_id: 2, doctor_id: 1, faculty_id: 1, patient_id:22+n, status: 1,
  phone_patient: "0343934499",
  address_patient: "Ngach 67 Goc De",
  day: Date.today + n,
  number: n+1)
end

7.times do |n|
  Appointment.create!(shift_work_id: n+3, doctor_id: 1, faculty_id: 1, patient_id:22+n, status: 1,
  phone_patient: "0343934499",
  address_patient: "Ngach 67 Goc De",
  day: Date.today + n,
  number: n+9)
end

8.times do |n|
  Comment.create!(commentable_id: 1,
  patient_id: 25,
  commentable_type: "User",
  content: "GOOD")
end

p = User.create!(id: 40, user_name: Faker::Name.name,
  full_name: Faker::Name.name,
  email: "admin@gmail.com",
  role: "Admin",
  password: "111111",
  password_confirmation: "111111",
  confirmed_at: Time.zone.now)
p.image.attach io: File.open(Rails.root
  .join("app", "assets", "images", "default_avatar.png")),
  filename: "default_avatar.png"
p.save

d = ArticleCategory.create!(id: 1,
  article_category_name: "Sức khoẻ cộng đồng")
d.save

d = ArticleCategory.create!(id: 2,
  article_category_name: "Mẹo vặt đời sống")
d.save

d = ArticleCategory.create!(id: 3,
  article_category_name: "Tin tức Sự kiện")
d.save

d = ArticleCategory.create!(id: 4,
  article_category_name: "Quy trình khám chữa bệnh")
d.save
