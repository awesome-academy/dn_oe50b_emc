Rails.application.routes.draw do
  get "/admin/home", to:"static_pages_admin#home", as: :home
  get "/admin/create", to:"static_pages_admin#create", as: :create
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    root "static_pages#home"

    get "home", to: "static_pages#home"
  end
end
