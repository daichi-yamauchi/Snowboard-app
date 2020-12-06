Rails.application.routes.draw do
  root 'static_pages#home'
  get '/help', to: 'static_pages#help' # 未実装
  get '/signup', to: 'users#new'
  resources :users
end
