Rails.application.routes.draw do
  ## Main landing page
  root 'photos#index'

  ## Authentication
  # Signup
  get 'users/new'  => 'users#new'
  # Signup form submission
  post 'users' => 'users#create'

  ## Sessions
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  delete '/logout' => 'sessions#destroy'

  ## Photos
  resources 'photos' do
    member do
      get '/tweet' => 'photos#tweet'
    end
  end

  ## OAuth
  get '/oauth/callback' => 'application#callback'
end
