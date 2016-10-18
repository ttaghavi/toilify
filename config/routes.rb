Rails.application.routes.draw do
  resources :tracks, only: [:index, :update, :destroy] do
    get 'search', on: :collection
    get 'login', on: :collection
  end

  get '/', to: 'tracks#index' 
  get '/auth/spotify/callback', to: 'tracks#spotify_callback'
end
