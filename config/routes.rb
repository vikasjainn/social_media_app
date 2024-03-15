Rails.application.routes.draw do
  root "articles#index"
  
  post '/articles/:article_id/likes', to: 'likes#create', as: 'article_likes'
  post '/comments/:comment_id/likes', to: 'likes#create', as: 'comment_likes'
  get '/articles/:article_id/likes', to: 'likes#article_likes'
  get '/comments/:comment_id/likes', to: 'likes#comment_likes'
  delete '/likes/:id', to: 'likes#destroy'
  
  get '/articles/:article_id/comments', to: 'comments#index', as: 'article_comments'
  post '/articles/:article_id/comments', to: 'comments#create'
  
  # Concept of Shallow nested routes
  get '/comments/:id', to: 'comments#show', as: 'comment'
  patch '/comments/:id', to: 'comments#update'
  delete '/comments/:id', to: 'comments#destroy'
  
  
  get '/articles', to: 'articles#index', as: 'articles'
  post '/articles', to: 'articles#create'
  get '/articles/:id', to: 'articles#show', as: 'article'
  patch '/articles/:id', to: 'articles#update'
  delete '/articles/:id', to: 'articles#destroy'
  
  
  get '/users', to: 'users#index'
  post '/users', to: 'users#create'
  get '/users/:id', to: 'users#show'
  put '/users/:id', to: 'users#update'
  delete '/users/:id', to: 'users#destroy'
  
  get '/friendships', to: 'friendships#index'
  post '/friendships/:friend_id', to: 'friendships#create'
  patch '/friendships/:friend_id', to: 'friendships#update'
  put '/friendships/:friend_id', to: 'friendships#reject'
  get '/friendships/pending_requests', to: 'friendships#pending_requests', as: 'pending_friend_requests'
  
  post '/password_resets', to: 'password_resets#create'
  put '/password_resets', to: 'password_resets#update'
  
  
  get '/blocked_users', to: 'blocked_users#index'
  post '/blocked_users/:user_id', to: 'blocked_users#create'
  delete '/blocked_users/:user_id', to: 'blocked_users#destroy'
  
  get '/account_verification/:confirm_token', to: 'account_verifications#confirm_email', as: 'confirm_email'

  post '/refresh_access_token/:refresh_token', to: 'authentication#refresh_access_token'

  get '/shares', to: 'shares#index'
  post '/shares/:article_id', to: 'shares#create'
  delete '/shares/:id', to: 'shares#destroy'
  
  post '/login', to: 'authentication#login'
  get '/*a', to: 'application#not_found'
end