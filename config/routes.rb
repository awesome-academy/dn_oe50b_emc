Rails.application.routes.draw do
  namespace :admin do
    resources :orders, except: %i(create destroy)
    resources :products
  end
  get "password_resets/new"
  get "password_resets/edit"

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    root "static_pages#home"

    get "home", to: "static_pages#home", as: :home_client
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    get "orders/new"
    resources :carts, only: [:index] do
      collection do
        post "add_to_cart/:id", to: "carts#add_to_cart", as: "add_to"
        put "update/:id", to: "carts#update", as: "update_to"
        delete "delete/:id", to: "carts#delete", as: "delete_from"
      end
    end
    resources :users
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
