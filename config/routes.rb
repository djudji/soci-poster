Rails.application.routes.draw do
  root 'pages#home'
  devise_for :users, controllers: { registrations: 'registrations' }
  get 'dashboard', to: 'pages#dashboard'
  resources :posts

  get 'auth/:provider/callback', to: 'connections#create'
  get 'auth/failure', to: 'connections#omniauth_failure'
  resources :connections, only: :destroy
end
