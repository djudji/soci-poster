Rails.application.routes.draw do
  root 'pages#home'
  devise_for :users, controllers: { registrations: 'registrations' }
  get 'dashboard', to: 'pages#dashboard'

  get 'auth/:provider/callback', to: 'connections#create'
  resources :connections, only: :destroy
end
