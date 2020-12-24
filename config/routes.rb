Rails.application.routes.draw do
  namespace :api do
    resources :users, only: [:create, :update, :index]
    resources :session, only: [:create, :destroy]
    resources :roles, only: [:index]
  end
end
