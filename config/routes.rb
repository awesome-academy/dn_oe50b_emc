Rails.application.routes.draw do
  default_url_options :host => "localhost:3000"
  namespace :admin do
    resources :orders, except: %i(create destroy) do
      member do
        put :approve
        put :reject
      end
    end
    resources :products
  end
  get "password_resets/new"
  get "password_resets/edit"

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    root "static_pages#home"

    get "home", to: "static_pages#home", as: :home_client

    devise_for :users

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
    resources :static_pages, only: [:index, :show]
    resources :account_activations, only: :edit
    resources :password_resets, except: %i(index show destroy)
    resources :orders, only: [:new, :create, :index] do
      member do
        put :update_status
      end
      resources :order_details, only: [:index]
    end
  end

end
