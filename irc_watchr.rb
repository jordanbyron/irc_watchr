require "rubygems"
require "bundler/setup"

require 'isaac'
require "#{File.dirname(__FILE__)}/bot_config"
require 'rest-client'

helpers do
  def send_message(channel, nick, message)
    RestClient.post 'https://api.prowlapp.com/publicapi/add', 
      :application => channel, 
      :event       => nick, 
      :description => message,
      :apikey      => API_KEY,
      :priority    => 2
  end
end

on :channel do
  send_message(channel, nick, message)
  quit "My work here is done. jordanbyron will be with you shortly."
end