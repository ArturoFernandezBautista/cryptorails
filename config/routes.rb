Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/documents', to: 'document#index'
  get '/document/new', to: 'document#new'
  post '/document/create', to: 'document#create'
  delete '/document/destroy', to: 'document#delete_all'

  get '/wallets', to: 'wallet#index'
  root 'document#index'
end
