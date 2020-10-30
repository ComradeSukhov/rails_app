require 'sidekiq/web'

Rails.application.routes.draw do

  namespace :admin do
    root 'welcome#index'
  end

  resource :login, only: [:show, :create, :destroy]
  resources :users 
  resources :orders do
  
    member do
      get 'approve'
      get 'calc'
    end
  
    collection do
      get 'first'
      get 'check'
    end
  end
  
  mount Sidekiq::Web => '/sidekiq'
  mount GrapeApi => '/api'
  mount GrapeSwaggerRails::Engine => '/swagger'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

end
