require "rails_helper"

RSpec.feature "Signin", type: :feature do
  let!(:patient) {FactoryBot.create :user, role: "Patient"}
  let!(:staff) {FactoryBot.create :user, role: "Staff"}
  let!(:doctor) {FactoryBot.create :user, role: "Doctor"}
  let!(:admin) {FactoryBot.create :user, role: "Admin"}

  before do
    visit signin_path
  end

  feature "Signin success" do
    scenario "role: Patient" do
      fill_in "session[email]", with: patient.email
      fill_in "session[password]", with: Settings.default_password
      click_button "commit"
      expect(page).to have_current_path("/en")
    end

    scenario "role: Admin" do
      fill_in "session[email]", with: admin.email
      fill_in "session[password]", with: Settings.default_password
      click_button "commit"
      expect(page).to have_current_path("/en/admins/dashboard")
    end

    scenario "role: Doctor" do
      fill_in "session[email]", with: doctor.email
      fill_in "session[password]", with: Settings.default_password
      click_button "commit"
      expect(page).to have_current_path("/en")
    end

    scenario "role: Staff" do
      fill_in "session[email]", with: staff.email
      fill_in "session[password]", with: Settings.default_password
      click_button "commit"
      expect(page).to have_current_path("/en")
    end
  end

  feature "Signin failed" do
    scenario "Email not exactly" do
      fill_in "session[email]", with: Settings.fail_email
      fill_in "session[password]", with: Settings.default_password
      click_button "commit"
      expect(page).to have_text I18n.t("invalid")
      expect(page).to have_current_path("/en/signin")
    end

    scenario "Password not exactly" do
      fill_in "session[email]", with: admin.email
      fill_in "session[password]", with: Settings.fail_password
      click_button "commit"
      expect(page).to have_text I18n.t("invalid")
      expect(page).to have_current_path("/en/signin")
    end

    scenario "Email not filled" do
      fill_in "session[password]", with: Settings.default_password
      click_button "commit"
      expect(page).to have_text I18n.t("invalid")
      expect(page).to have_current_path("/en/signin")
    end

    scenario "Password not filled" do
      fill_in "session[email]", with: admin.email
      click_button "commit"
      expect(page).to have_text I18n.t("invalid")
      expect(page).to have_current_path("/en/signin")
    end

    scenario "Password and email not filled" do
      click_button "commit"
      expect(page).to have_text I18n.t("invalid")
      expect(page).to have_current_path("/en/signin")
    end
  end
end
