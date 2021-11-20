Rails.application.routes.draw do
  get "static_pages/home"
  get "/admin/home", to:"static_pages_admin#home", as: :home
  get "/admin/create", to:"static_pages_admin#create", as: :create
end
