Rails.application.routes.draw do
  namespace :api do
    resources :users, only: [:create, :update, :index, :destroy, :show]
    resources :session, only: [:create, :destroy]
    resources :roles, only: [:index]
    resources :reviews, only: [:create, :index, :update]
    resources :review_dates, only: [:create, :update]
    resources :review_list_for_manager, only: [:index]
    resources :over_all_review, only: [:index]
    resources :questions, only: [:create, :update]
  end
end
