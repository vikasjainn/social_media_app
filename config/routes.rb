Rails.application.routes.draw do
  root 'posts#index'

  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :posts, only: [:index, :new, :create, :show, :destroy] do
    resources :comments, only: [:create, :destroy]
    resources :likes, only: [:create, :destroy]
  end

end
