require 'rspotify'

class AdminController < ApplicationController
  def index
  end

  def spotify
    binding.pry
    spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    # Now you can access user's private data, create playlists and much more

    # Access private data
    render json: spotify_user.playlists   #=> "example@email.com"
  end
end
