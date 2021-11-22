Rails.application.routes.draw do
  get "/admin/home", to:"static_pages_admin#home", as: :home
  get "/admin/create", to:"static_pages_admin#create", as: :create

end
