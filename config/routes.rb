Rails.application.routes.draw do
  get 'admin/index'
  get '/auth/spotify/callback', to: 'admin#spotify'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
