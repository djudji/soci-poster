Rails.application.routes.draw do
  authenticated :user, -> (user) { user.admin? } do
    mount Delayed::Web::Engine, at: '/jobs'
  end
  root 'pages#home'
  devise_for :users, controllers: { registrations: 'registrations' }
  get 'dashboard', to: 'pages#dashboard'
  resources :posts do
    member do
      patch :cancel
    end
  end

  get 'auth/:provider/callback', to: 'connections#create'
  get 'auth/failure', to: 'connections#omniauth_failure'
  resources :connections, only: :destroy
end
