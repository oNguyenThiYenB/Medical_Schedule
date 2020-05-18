require "rails_helper"

RSpec.describe Appointment, type: :model do
  let!(:doctor) {FactoryBot.create :doctor}
  let!(:patient) {FactoryBot.create :patient}

  subject {FactoryBot.build(:appointment, doctor_id: doctor.id, patient_id: patient.id)}

  describe "Databases" do
    it {expect(subject).to have_db_column(:doctor_id).of_type :integer}
    it {expect(subject).to have_db_column(:patient_id).of_type :integer}
    it {expect(subject).to have_db_column(:phone_patient).of_type :string }
    it {expect(subject).to have_db_column(:address_patient).of_type :string }
    it {expect(subject).to have_db_column(:day).of_type :date }
  end

  describe "Is valid with valid attributes" do
    it {expect(subject).to be_valid}
  end

  describe "Associations" do
    it {expect(subject).to belong_to :patient}
    it {expect(subject).to belong_to :doctor}
  end

  describe "enum" do
    it { is_expected.to define_enum_for(:status).with_values([:waiting, :accept, :cancel]) }
  end

  describe "Validations" do
    it { is_expected.to validate_presence_of(:phone_patient).with_message(I18n.t("errors_blank")) }
    it { is_expected.to validate_presence_of(:address_patient).with_message(I18n.t("errors_blank")) }
    it { is_expected.to validate_presence_of(:day).with_message(I18n.t("errors_blank")) }

    context "Phone invalid" do
      before {subject.phone_patient = nil}
      it {is_expected.not_to be_valid}
    end

    context "Phone greater than invalid" do
      before {subject.phone_patient = "0" * Settings.factories.appointment.max_number_phone}
      it {is_expected.not_to be_valid}
    end

    context "Address invalid" do
      before {subject.address_patient = nil}
      it {is_expected.not_to be_valid}
    end

    context "Address greater than invalid" do
      before {subject.address_patient = "a" * Settings.factories.appointment.max_address}
      it {is_expected.not_to be_valid}
    end
  end

  describe "Scopes" do
    let(:u1) { FactoryBot.create :appointment, doctor_id: doctor.id, patient_id: patient.id,
      created_at: Date.today}
    let(:u2) { FactoryBot.create :appointment, doctor_id: doctor.id, patient_id: patient.id,
      created_at: Date.today + 1 }
    let(:u3) { FactoryBot.create :appointment, doctor_id: doctor.id, patient_id: patient.id,
      created_at: Date.today + 2, start_time: "16:00"}

    it "appointment by creates_asc" do
      expect(Appointment.by_created_at).to eq [u1,u2,u3]
    end

    it "appointment exists" do
      expect(Appointment.appointment_exists(doctor.id, "15:15", Date.today )).to eq [u1,u2]
    end

    it "appointment not exists" do
      expect(Appointment.appointment_exists(doctor.id, "00:00", Date.today )).to eq []
    end
  end
end
