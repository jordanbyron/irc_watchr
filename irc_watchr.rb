require "rubygems"
require "bundler/setup"

require 'isaac'
require_relative "bot_config"
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

on :channel, /!notify_me/ do
  @notification = true
end

on :channel, /!kill irc_watchr/ do
  quit "Goodbye cruel world!" if @authorized.include?(nick)
end

on :channel do
  if @notification && @authorized.include?(nick)
    send_message(channel, nick, message)
    @notification = false
  end
end