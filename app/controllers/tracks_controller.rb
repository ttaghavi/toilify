class TracksController < ApplicationController
  PLAYLIST_NAME = 'toilify_playlist'.freeze
  TRACKS_PER_REQUEST = 100

  before_action :require_token
  skip_before_action :require_token, only: [:spotify_callback, :login]

  def login
  end

  def index
    tracks = []
    playlist = get_playlist()
    loops = playlist.total / TRACKS_PER_REQUEST

    for current_iteration in 0..loops
      tracks.concat(playlist.tracks(
        offset: (current_iteration * TRACKS_PER_REQUEST) + 1,
        limit: TRACKS_PER_REQUEST
      ))
    end

    render template: "tracks/index", locals: { tracks: tracks }
  end

  def search
    render nothing: true and return if params['query'].empty?

    tracks = RSpotify::Track.search(params['query'], limit: 10)
    render template: 'tracks/search', layout: false, locals: { tracks: tracks }
  end

  def update
    # TODO: check if track already in playlist
    #       meh... gotta retrieve all the tracks of the playlist (limit 100 per request)
    track = RSpotify::Track.find(params['id'])
    playlist = get_playlist()
    playlist.add_tracks!([track])
  end

  def destroy
    track = RSpotify::Track.find(params['id'])
    playlist = get_playlist()
    playlist.remove_tracks!([track]) 
  end

  def spotify_callback
    spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    session['spotify_user'] = spotify_user.to_hash
    redirect_to action: 'index'
  end

  private

  def require_token
    redirect_to action: 'login' if session['spotify_user'].nil?
  end

  def get_playlist()
    spotify_user = RSpotify::User.new(session['spotify_user'])
    playlist = spotify_user.playlists.find { |p| p.name == PLAYLIST_NAME }
    if playlist.nil?
      playlist = spotify_user.create_playlist!(PLAYLIST_NAME)
    end
    return playlist
  end
end
