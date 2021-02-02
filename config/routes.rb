Rails.application.routes.draw do
  namespace :api do
    resources :users, only: [:create, :update, :index, :destroy, :show]
    resources :session, only: [:create, :destroy]
    resources :roles, only: [:index]
    resources :reviews, only: [:create, :index, :update, :show]
    resources :review_dates, only: [:index, :create, :update]
    resources :review_list_for_manager, only: [:index]
    resources :goal, only: [:index]
    resources :questions, only: [:index, :create, :update]
  end
end
