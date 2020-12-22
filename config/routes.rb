Rails.application.routes.draw do
  namespace :api do
    resources :users, only: [:create, :index]
    resources :session, only: [:create, :destroy]
  end
end
