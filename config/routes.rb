Rails.application.routes.draw do
  namespace :api do
    resources :users, only: [:create, :destroy, :index]
    resources :registration, only: [:create]
  end
end
