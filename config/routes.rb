Rails.application.routes.draw do

  namespace :review_system do
    resources :users
    resources :session
    resources :roles
    resources :reviews
    resources :review_dates
    resources :question_types
    resources :questions
    resources :feedback_by_reporting_users
    resources :question_for_users
    get '/feedback_by_reporting_users/:feedback_for_user_id', to: 'feedback_by_reporting_users#show'
    get '/show_reviews/:user_id', to: 'reviews#show_reviews'
    get '/questions/manager_question_list', to: 'questions#manager_question_list'
    get '/questions/employee_question_list', to: 'questions#employee_question_list'
    get '/questions/:id', to: 'questions#show'
    put '/feedback_by_reporting_users/:user_id', to: 'feedback_by_reporting_users#update'
    get '/asset_items_of_user/:id', to: 'users#asset_items_of_user'
  end
  namespace :inventory_system do
    resources :assets
    resources :asset_fields
    resources :asset_items
    resources :asset_item_values
    resources :asset_tracks
    patch '/allocation_of_asset_items/:id', to: 'asset_items#allocation_of_assets'
    get '/show_asset_items/:id', to: 'assets#show_asset_items'
    patch '/deallocation_of_asset_items/:id', to: 'asset_items#deallocation_of_assets'
    get '/allocated_asset_items', to: 'asset_items#list_of_allocated_assets'
    get '/free_asset_items', to: 'asset_items#list_of_free_assets'
    get '/allocated_asset_items_for_asset/:id', to: 'assets#show_allocated_assets'
    get '/free_assets_of_asset/:id', to: 'assets#show_free_assets'
  end
end
