Rails.application.routes.draw do
  get "payments/new"
  get "payments/create"
  devise_for :customer_users, controllers: { registrations: "customer_users/registrations" }
  get "products/index"
  get "pages/show"
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
  root "products#index"
  get "/pages/:title", to: "pages#show", as: :page
  resources :products, only: [ :index, :show ]

  # based on categories display product
  resources :categories, only: [] do
    resources :products, only: :index, controller: "categories/products"
  end

  # display  specific product
  resources :products, only: [ :index, :show ]

  resources :customer_users, only: [ :show ]


  resources :customer_users, only: [ :show ] do
    member do
      get :edit_profile
      patch :update_profile
    end
  end


  resource :cart, only: [ :show ] do
    post :add_to_cart, to: "carts#add_to_cart"
  end

  resource :cart, only: [ :show ] do
    delete :remove_item, to: "carts#remove_item", as: :remove_item
  end


  resources :orders, only: [ :show ]

  resources :checkouts, only: [ :new, :create ] do
    collection do
      get :fetch_tax_rates
    end
  end







  direct :rails_blob do |blob|
    "#{blob.service_url}"
  end
end
