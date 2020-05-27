Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "/home", to: "static_pages#home"
    get "/about", to: "static_pages#about"

    devise_for :users, controllers: {
      registrations: "users/registrations",
      confirmations: "users/confirmations",
    }
    get "admin/dashboard", to: "admin/dashboard#index"

    resources :users, only: :show
    resources :patients do
      resources :medical_records
    end
    resources :faculties
    resources :doctors do
      resources :comments
      resources :schedules
    end
    resources :articles
    resources :staffs
    resources :appointments do
      collection do
        get "/for_facuty_id/:faculty_id", to: "appointments#for_faculty_id"
        get "/for_doctor_id/:doctor_id", to: "appointments#for_doctor_id"
        get "for_date_picker(/:date_picker)", to: "appointments#for_date_picker"
      end
    end
    resources :admins
    namespace :admin do
      resources :staffs
      resources :admins
      resources :patients
      resources :doctors
    end
  end
end
