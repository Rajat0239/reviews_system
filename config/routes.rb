Rails.application.routes.draw do
  namespace :api do
    resources :user, only: [:create, :destroy, :index]
    resources :registration, only: [:create]
  end
end
