require 'rspotify/oauth'

Rails.application.config.middleware.use OmniAuth::Builder do
    provider :spotify, "0ecfd57acbb84faa91b5f6d0c4cdaf64", "db37f56a9949446a9b9dfcc3490ff8e5", 
        scope: 'user-read-email playlist-modify-public user-library-read user-library-modify user-top-read'
end
