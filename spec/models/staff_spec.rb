require "rails_helper"

RSpec.describe Staff, type: :model do
  subject {FactoryBot.build :staff}

  describe "Associations" do
    it { is_expected.to have_many(:news).dependent(:destroy) }
  end

  describe "image" do
    it {
      subject.image.attach(io: File.open(Rails.root.join("app", "assets", "images", "default_avatar.png")),
        filename: "default_avatar.png")
      expect(subject.image).to be_attached
    }
  end

  describe "Validations" do
    it { is_expected.to validate_presence_of(:user_name).with_message(I18n.t("errors_blank")) }
    it { is_expected.to validate_length_of(:user_name).is_at_most(Settings.max_user_name)}
    it { is_expected.to validate_presence_of(:full_name).with_message(I18n.t("errors_blank")) }
    it { is_expected.to validate_length_of(:full_name).is_at_most(Settings.max_user_name)}
    it { is_expected.to validate_presence_of(:email).with_message(I18n.t("errors_blank")) }
    it { is_expected.to allow_value("yen@gmail.com").for(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive.with_message(I18n.t("errors_taken")) }
    it { is_expected.to validate_presence_of(:password).with_message(I18n.t("errors_blank")) }
    it { is_expected.to validate_length_of(:password).is_at_least(Settings.min_pass) }
    it { is_expected.to validate_confirmation_of(:password) }
  end

  describe "Scopes" do
    let(:u1) { FactoryBot.create :staff, full_name: "yen" }
    let(:u2) { FactoryBot.create :staff, full_name: "phuong" }

    it "staff order by full_name asc" do
      expect(Staff.order_by_name).to eq [u2,u1]
    end
  end
end
