Rails.application.routes.draw do
  namespace :api do
    resources :users, only: [:create, :update, :index, :destroy, :show]
    resources :session, only: [:create, :destroy]
    resources :roles, only: [:index]
    resources :reviews, only: [:create, :index, :update, :show]
    resources :review_dates, only: [:index, :create, :update]
    resources :question_types, only: [:index]
    resources :questions, only: [:index, :create, :update]
    get '/show_reviews_of_user/:id', to: 'users#show_reviews_of_user'
  end
end
