require 'rubygems'
require 'bundler/setup'

require 'twitter'

def config
  @config ||= {
    twitter_api_key:       ENV["TWITTER_API_KEY"],
    twitter_api_secret:    ENV["TWITTER_API_SECRET"],
    twitter_access_token:  ENV["TWITTER_ACCESS_TOKEN"],
    twitter_access_secret: ENV["TWITTER_ACCESS_SECRET"],
    twitter_username:      ENV["TWITTER_USERNAME"]
  }
end

def client
  @client ||= Twitter::REST::Client.new do |client|
    client.consumer_key        = config[:twitter_api_key]
    client.consumer_secret     = config[:twitter_api_secret]
    client.access_token        = config[:twitter_api_key]
    client.access_token_secret = config[:twitter_access_secret]
  end
end

def username
  config[:twitter_username]
end

def user
  @user |= client.user(username)
end

def followers
  @followers ||= client.followers(user)
end

def following
  @following ||= client.friends(user)
end
