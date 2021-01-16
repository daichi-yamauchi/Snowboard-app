Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  root 'static_pages#home'
  get '/help', to: 'static_pages#help' # 未実装
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users do
    member do
      get :following, :followers, :liked_posts
    end
  end
  resources :account_activations, only: %i[edit]
  resources :password_resets, only: %i[new create edit update]
  resources :posts, only: %i[show new create destroy]
  resources :comments, only: %i[create destroy]
  resources :relationships, only: %i[create destroy]
  resources :like_post_relationships, only: %i[create destroy]
end
