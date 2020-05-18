require "rails_helper"

RSpec.describe AppointmentsController, type: :controller do
  let!(:doctor) {FactoryBot.create :doctor}
  let!(:patient) {FactoryBot.create :patient}
  let!(:appointments) { FactoryBot.create_list :appointment, 2, doctor_id: doctor.id, patient_id: patient.id }

  describe "Not signin" do
    context "GET #index" do
      before {get :index}

      it "redirect to login page" do
        expect(response).to redirect_to(signin_path)
      end

      it "should found" do
        expect(response).to have_http_status(302)
      end
    end

    context "GET #new" do
      before {get :new}

      it "redirect to login page" do
        expect(response).to redirect_to(signin_path)
      end

      it "should found" do
        expect(response).to have_http_status(302)
      end
    end

    context "POST #create " do
      before do
        post :create, params: {appointment: FactoryBot.attributes_for(:appointment).merge(doctor_id: doctor.id, patient_id: patient.id, status: "accept")}
      end

      it "redirect to signin page" do
        expect(response).to redirect_to(signin_path)
      end

      it "should found" do
        expect(response).to have_http_status(302)
      end
    end

    context "PATCH #update" do
      before do
        patch :update, params: {id: appointments.first.id}
      end

      it "redirect to login page" do
        expect(response).to redirect_to(signin_path)
      end

      it "should found" do
        expect(response).to have_http_status(302)
      end
    end

    context "DELETE #destroy" do
      before do
        delete :destroy, params: {id: appointments.first.id}
      end

      it "redirect to login page" do
        expect(response).to redirect_to(signin_path)
      end

      it "should found" do
        expect(response).to have_http_status(302)
      end
    end
  end

  describe "signin with staff account" do
    let(:staff) {FactoryBot.create :staff}

    before do
      log_in staff
    end

    context "GET #index" do
      before do
        get :index
      end

      it "should be success" do
        expect(response).to have_http_status(200)
      end

      it "render index template" do
        expect(response).to render_template :index
      end

      it "assigns @appointments to appointments list" do
        expect(assigns(:appointments)).to match_array(appointments)
      end
    end

    context "PATCH #update"do
      context "update status success when has not duplicate appointment accepted" do
        let(:appointment) {FactoryBot.create :appointment, doctor_id: doctor.id, patient_id: patient.id}

        before do
          patch :update, params: {id: appointment.id, appointment: {status: "accept"}}
        end

        it "should be found" do
          expect(response).to have_http_status(302)
        end

        it "redirect to appointment list" do
          expect(response).to redirect_to(appointments_path)
        end
      end

      context "update status fail when has duplicate appointment accepted" do
        let!(:patient2) {FactoryBot.create :patient}
        let!(:appointment1) {FactoryBot.create :appointment, doctor_id: doctor.id, patient_id: patient.id, status: "accept"}
        let!(:appointment2) {FactoryBot.create :appointment, doctor_id: doctor.id, patient_id: patient2.id}

        before do
          patch :update, params: {id: appointment2.id, appointment: {status: "accept"}}
        end

        it {expect(flash[:danger]).to eq I18n.t("already_have_an_appointment")}

        it "should be found" do
          expect(response).to have_http_status(302)
        end

        it "redirect to appointment list" do
          expect(response).to redirect_to(appointments_path)
        end
      end
    end

    context "DELETE #destroy" do
      let(:appointment) {FactoryBot.create :appointment, doctor_id: doctor.id, patient_id: patient.id}

      before do
        delete :destroy, params: {id: appointment.id}
      end

      it "should found" do
        expect(response).to have_http_status(302)
      end

      it "redirect to root " do
        expect(response).to redirect_to(root_url)
      end
    end

    context "DELETE failed #destroy" do
      let(:appointment) {FactoryBot.create :appointment, doctor_id: doctor.id, patient_id: patient.id}

      before do
        delete :destroy, params: {id: appointment.id + Settings.delete_test}
      end

      it "not success" do
        expect(response).to have_http_status(302)
      end

      it "redirect to root " do
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "signin with patient account" do
    let(:staff) {FactoryBot.create :staff}

    before do
      log_in patient
    end

    context "GET #new" do
      before do
        get :new
      end

      it "should be success" do
        expect(response).to have_http_status(200)
      end

      it "render new template" do
        expect(response).to render_template(:new)
      end

      it "new appointment" do
        expect(assigns(:appointment)).to be_a_new(Appointment)
      end
    end

    context "POST #create" do
      context "with valid attributes" do
        before do
          log_in patient
          post :create, params: {appointment: FactoryBot.attributes_for(:appointment).merge(doctor_id: doctor.id, patient_id: patient.id, status: "accept")}
        end

        it "should found" do
          expect(response).to have_http_status(302)
        end

        it "redirect root" do
          expect(response).to redirect_to :root
        end
      end

      context "with invalid attributes" do
        before do
          log_in patient
          post :create, params: {appointment: FactoryBot.attributes_for(:appointment).merge( patient_id: patient.id, status: "accept")}
        end

        it "should found" do
          expect(response).to have_http_status(200)
        end

        it "re-render new template" do
          expect(response).to render_template :new
        end
      end
    end
  end
end
