require 'net/telnet'

class SpopdClient
  PLAYLIST_NAME = 'toilify_playlist'.freeze

  attr_reader :client

  def initialize(attemps: 1, wait: 0)
    connect!(attemps: attemps, wait: wait)
    ObjectSpace.define_finalizer(self, proc { @client.close })
  end

  def connect!(attemps: 1, wait: 0)
    attemps.times do
      begin
        @client = Net::Telnet.new(
          'Host' => 'localhost',
          'Port' => 6602,
          # 'Timeout' => false,
          'Waittime' => 0.1,
          'Prompt' => /.*/,
          'Telnetmode' => false
        )
        return
      rescue Errno::ECONNREFUSED
        sleep(wait.to_f / 1000)
      end
    end
    raise('Could not connect to spopd')
  end

  def playlist_index
    @playlist_index ||= begin
      rp = client.cmd('ls')
      # remove the first 11 characters: "spop 0.0.1\n"
      json = JSON.parse(rp[11..-1])
      playlist = json['playlists'].find { |pl| pl['name'] == PLAYLIST_NAME }
      raise("Playlist #{PLAYLIST_NAME} not found") if playlist.nil?
      playlist['index'].to_s.rjust(2, '0')
    end
  end

  def play
    client.cmd("play #{playlist_index}")
  end
end
