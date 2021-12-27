Rails.application.routes.draw do
  namespace "api" do
    namespace "v1" do
      resources :products
    end
  end
  devise_for :users, only: :omniauth_callbacks,
              controllers: {omniauth_callbacks: "omniauth_callbacks"}

  default_url_options :host => "localhost:3000"
  namespace :admin do
    resources :orders, except: %i(create destroy) do
      member do
        put :approve
        put :reject
      end
    end
    resources :products
    resources :statistics, only: %i(index)
    get :statistic_month, to: "statistics#month"
    get :statistic_quarter, to: "statistics#quarter"
    get :statistic_year, to: "statistics#year"

    resources :statistic_products, only: %i(index)
    get :statistic_product_by_period, to: "statistic_products#chart_by_period"
  end
  get "password_resets/new"
  get "password_resets/edit"

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    root "static_pages#home"

    get "home", to: "static_pages#home", as: :home_client

    devise_for :users, skip: :omniauth_callbacks

    namespace :api do
      namespace :v1 do
        devise_scope :user do
          post "sign_up", to: "registrations#create"
          post "sign_in", to: "sessions#create"
          delete "sign_out", to: "sessions#destroy"
        end
      end
    end

    as :user do
      get "signup", to: "devise/registrations#new"
      get "login", to: "devise/sessions#new"
      delete "logout", to: "devise/sessions#destroy"
    end

    get "orders/new"
    resources :carts, only: [:index] do
      collection do
        post "add_to_cart/:id", to: "carts#add_to_cart", as: "add_to"
        put "update/:id", to: "carts#update", as: "update_to"
        delete "delete/:id", to: "carts#delete", as: "delete_from"
      end
    end
    resources :notifications, only: [:show]
    resources :static_pages, only: [:index, :show] do
      member do
        get :filter_by_category
        get :filter_by_status
      end
    end
    resources :account_activations, only: :edit
    resources :password_resets, except: %i(index show destroy)
    resources :orders, only: [:new, :create, :index] do
      member do
        put :update_status
      end
      resources :order_details, only: [:index]
    end

    resources :notificationads, only: %i(index) do
      member do
        put :update_to_read
      end
    end
  end
end
