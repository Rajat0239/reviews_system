Rails.application.routes.draw do
  namespace :api do
    resources :users, only: [:create, :update, :index, :destroy, :show]
    resources :session, only: [:create, :destroy]
    resources :roles, only: [:index]
    resources :reviews, only: [:create, :index, :update, :show]
    resources :review_dates, only: [:index, :create, :update]
    resources :question_types, only: [:index]
    resources :questions, only: [:index, :create, :update]
    resources :feedback_by_reporting_users, only: [:index, :create, :update]
    get '/feedback_by_reporting_users/:feedback_for_user_id', to: 'feedback_by_reporting_users#show'
  end
end
