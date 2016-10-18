require 'rspotify'

class AdminController < ApplicationController

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

end
