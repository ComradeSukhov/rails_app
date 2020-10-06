Rails.application.routes.draw do

  namespace :admin do
    root 'welcome#index'
  end
  
  resources :users 

  resources :orders do
  
    member do
      get 'approve'
      get 'calc'
    end
  
    collection do
      get 'first'
    end
  
  end
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

end
