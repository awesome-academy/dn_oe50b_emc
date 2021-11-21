Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    root "static_pages#home"
    get "home", to: "static_pages#home"
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"

    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    resources :users
  end

  get "/admin/products/new", to:"products#new", as: :new_product
  get "/admin/products/list", to:"products#list", as: :list_product
  post "/admin/create", to: "products#create", as: :create_product
  resources :products, only: %i(new create show edit update index destroy)

end
