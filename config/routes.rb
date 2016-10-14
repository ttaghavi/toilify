Rails.application.routes.draw do
  get 'admin/index'
  get '/auth/spotify/callback', to: 'admin#spotify_callback'
  get 'admin/playlist', to: 'admin#playlist'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
