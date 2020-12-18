Rails.application.routes.draw do
  namespace :api do
    resources :user, only: [:create, :destroy, :index]
  end
end
