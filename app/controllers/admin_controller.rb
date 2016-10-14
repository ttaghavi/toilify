require 'rspotify'

class AdminController < ApplicationController
  PLAYLIST_NAME = 'toilify_playlist'.freeze
  TRACKS_PER_REQUEST = 100

  def index
    @current_song = SpopdClient.new(attemps: 3, wait: 200).current_song
  end

  def play
    @current_song = SpopdClient.new(attemps: 3, wait: 200).play
    render json: { current_song: @current_song }
  end

  def next
    @current_song = SpopdClient.new(attemps: 3, wait: 200).next
    render json: { current_song: @current_song }
  end

  def stop
    SpopdClient.new(attemps: 3, wait: 200).next
  end

  def spotify_callback
    spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    session['spotify_user'] = spotify_user.to_hash
    redirect_to action: 'playlist'
  end

  def playlist
    tracks = []
    spotify_user = RSpotify::User.new(session['spotify_user'])
    #playlist = create_toilify_playlist(spotify_user)
    playlist = get_playlist(spotify_user, 'Test')
    loops = playlist.total / TRACKS_PER_REQUEST

    for current_iteration in 0..loops
      tracks.concat(playlist.tracks(
        offset: (current_iteration * TRACKS_PER_REQUEST) + 1,
        limit: TRACKS_PER_REQUEST
      ))
    end

    render template: "admin/list", locals: { tracks: tracks }
  end

  private

  def get_playlist(spotify_user, name)
    return spotify_user.playlists.find { |p| p.name == name }
  end

  def create_toilify_playlist(spotify_user)
    playlist = spotify_user.playlists.find { |p| p.name == PLAYLIST_NAME }
    if playlist.nil?
      playlist = spotify_user.create_playlist!(PLAYLIST_NAME)
    end
    return playlist
  end
end
