Rails.application.routes.draw do

  namespace :review_system do
    resources :reviews
    resources :review_dates
    resources :question_types
    resources :questions
    resources :feedback_by_reporting_users, only: [:index, :create]
    resources :question_for_users
    get '/feedback_by_reporting_users/:feedback_for_user_id', to: 'feedback_by_reporting_users#show'
    get '/show_reviews/:user_id', to: 'reviews#show_reviews'
    get '/questions/question_list/:role', to: 'questions#question_list'
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
    resources :asset_requests
    get '/show_assets_with_free_items', to: 'assets#show_assets_with_free_items'
    patch '/allocation_of_asset_items/:id', to: 'asset_items#allocation_of_assets'
    get '/show_asset_items/:id', to: 'assets#show_asset_items'
    patch '/deallocation_of_asset_items/:id', to: 'asset_items#deallocation_of_assets'
    get '/allocated_asset_items', to: 'asset_items#list_of_allocated_assets'
    get '/free_asset_items', to: 'asset_items#list_of_free_assets'
    get '/allocated_asset_items_for_asset/:id', to: 'assets#show_allocated_assets'
    get '/free_assets_of_asset/:id', to: 'assets#show_free_assets'
    get '/show_assets_with_allocated_items', to: 'assets#show_assets_with_allocated_items'
  end
  namespace :users do
    resources :users
    resources :session
    resources :roles
    get '/user_inventory_list/:id', to: 'users#user_inventory_list'
  end
end
