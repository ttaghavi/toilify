require "#{Rails.root}/lib/spopd_client.rb"
# start spopd
# make sure you have spopd in your path!
system('killall spopd')
system('spopd || true')
