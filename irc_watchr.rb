require "rubygems"
require "bundler/setup"

require 'isaac'
require_relative "bot_config"
require 'rest-client'
require 'ruby-growl'

helpers do
  def growl
    @growl ||= Growl.new("127.0.0.1", "irc_watchr", ["message"], nil, GROWL_PASSWORD)
    
    @growl
  end
  
  def send_message(channel, nick, message)
    growl.notify("message", "#{channel}: #{nick}", message)
    
    RestClient.post('https://api.prowlapp.com/publicapi/add', 
      :application => channel, 
      :event       => nick, 
      :description => message,
      :apikey      => API_KEY,
      :priority    => 2)
  end
end

on :channel, /!notify_me/ do
  @notification[channel] = true
end

on :channel, /!kill irc_watchr/ do
  quit "Goodbye cruel world!" if @authorized.include?(nick)
end

on :channel do
  if @notification[channel] && @authorized.include?(nick)
    send_message(channel, nick, message)
    @notification[channel] = false
  end
end