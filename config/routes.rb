Rails.application.routes.draw do
  resources :events do
    post 'tags', on: :member
    get 'participants', on: :member
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :users, only: [:create, :show, :update, :destroy] do
    post 'register', on: :member
    get 'bucket', on: :member
  end
  resources :tags, only: [:index, :create, :update, :destroy]
  namespace :admin do
    resources :users, only: [:create, :show, :update, :destroy] do
      get 'events', on: :member
    end
  end
  post '/auth/login', to: 'authentication#login'
  post '/auth/admin/login', to: 'authentication#adminlogin'
end
