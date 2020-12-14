Rails.application.routes.draw do
  root 'static_pages#home'
  get '/help', to: 'static_pages#help' # 未実装
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users
  resources :account_activations, only: [:edit]
end
