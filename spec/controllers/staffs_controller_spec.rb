require "rails_helper"

RSpec.describe Admin::StaffsController, type: :controller do
  let!(:staffs) { FactoryBot.create_list :staff, 2 }

  describe "not signin" do
    context "GET #index" do
      before {get :index}

      it "should found" do
        expect(response).to have_http_status(302)
      end

      it "redirect to signin page" do
        expect(response).to redirect_to signin_path
      end
    end

    context "GET #new" do
      before {get :new}

      it "redirect to signin page" do
        expect(response).to redirect_to signin_path
      end

      it "should found" do
        expect(response).to have_http_status(302)
      end
    end

    context "POST #create" do
      before do
        post :create, params: {staff: {user_name: "yen"}}
      end

      it "redirect to signin page" do
        expect(response).to redirect_to signin_path
      end

      it "should found" do
        expect(response).to have_http_status(302)
      end
    end

    context "GET #edit" do
      before do
        get :edit, params: {id: staffs.first.id}
      end

      it "redirect to signin page" do
        expect(response).to redirect_to signin_path
      end

      it "should found" do
        expect(response).to have_http_status(302)
      end
    end

    context "PATCH #update" do
      before do
        patch :update, params: {id: staffs.first.id}
      end

      it "redirect to signin page" do
        expect(response).to redirect_to signin_path
      end

      it "should found" do
        expect(response).to have_http_status(302)
      end
    end

    context "DELETE #destroy" do
      before do
        delete :destroy, params: {id: 1}
      end

      it "redirect to signin page" do
        expect(response).to redirect_to signin_path
      end

      it "should found" do
        expect(response).to have_http_status(302)
      end
    end
  end

  describe "signin with admin account" do
    let!(:admin) {FactoryBot.create :user, role: "Admin"}

    before do
      log_in admin
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

      it "assigns @staffs to staffs list" do
        expect(assigns(:staffs)).to match_array staffs
      end
    end

    context "GET #new" do
      before do
        get :new
      end

      it "should be success" do
        expect(response).to have_http_status(200)
      end

      it "render new template" do
        expect(response).to render_template :new
      end

      it "assigns @staff to a new staff" do
        expect(assigns(:staff)).to be_a_new Staff
      end
    end

    context "POST #create" do
      context "with valid attributes" do
        before do
          post :create, params: {staff: FactoryBot.attributes_for(:staff).merge(user_name: "yen", password: "111111", password_confirmation: "111111")}
        end

        it "should found" do
          expect(response).to have_http_status(302)
        end

        it "redirects to the index template" do
          expect(response).to redirect_to admin_staffs_path
        end

        it "create staff successfully" do
          expect(assigns(:staff).user_name).to eq("yen")
        end
      end

      context "with invalid attributes" do
        before do
          post :create, params: {staff: FactoryBot.attributes_for(:staff).merge(email: "yen", password: "111111", password_confirmation: "111111")}
        end

        it "should found" do
          expect(response).to have_http_status(200)
        end

        it "re-render new template" do
          expect(response).to render_template :new
        end
      end
    end

    context "GET #edit" do
      let!(:staff) {FactoryBot.create :staff}

      before do
        get :edit, params: {id: staff.id}
      end

      it "should be success" do
        expect(response).to have_http_status(200)
      end

      it "render to edit staff template" do
        expect(response).to render_template :edit
      end
    end

    context "PATCH #update" do
      let!(:staff) {FactoryBot.create :staff}

      context "with valid attributes" do
        before do
          patch :update, params: {id: staff.id, staff: {user_name: "yen"}}
        end

        it "should found" do
          expect(response).to have_http_status(302)
        end

        it "redirects to the index template" do
          expect(response).to redirect_to admin_staffs_path
        end
      end

      context "with invalid attributes" do
        before do
          patch :update, params: {id: staff.id, staff: {email: "yen.com"}}
        end

        it "should found" do
          expect(response).to have_http_status(200)
        end

        it "re-render edit staff template" do
          expect(response).to render_template :edit
        end
      end
    end

    context "DELETE #destroy" do
      let!(:staff) {FactoryBot.create :staff}

      before do
        delete :destroy, params: {id: staff.id}
      end

      it "should found" do
        expect(response).to have_http_status(302)
      end

      it "redirects to the index template" do
        expect(response).to redirect_to admin_staffs_path
      end
    end

    context "DELETE failed #destroy" do
      let!(:staff) {FactoryBot.create :staff}

      before do
        delete :destroy, params: {id: staff.id + Settings.delete_test}
      end

      it "not success" do
        expect(response).to have_http_status(302)
      end

      it "redirects to the index template" do
        expect(response).to redirect_to admin_staffs_path
      end
    end
  end
end
