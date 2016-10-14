Rails.application.routes.draw do
  get 'admin/index'
  post 'admin/play'
  post 'admin/next'
  post 'admin/stop'
  get 'admin/search', to: 'admin#search'
  get 'admin/playlist', to: 'admin#playlist'
  get '/auth/spotify/callback', to: 'admin#spotify_callback'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
