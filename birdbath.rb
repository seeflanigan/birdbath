require 'rubygems'
require 'bundler/setup'

require 'twitter'

class Birdbath
  attr_reader  :follower_ids, :friend_ids, :username

  def initialize
    @username     = config[:twitter_username]
    @follower_ids = client.follower_ids(user).attrs[:ids]
    @friend_ids   = client.friend_ids(user).attrs[:ids]
  end

  # they follow us, we don't reciprocate
  def asymmetric_follower_ids
    @asymmetric_follower_ids ||= follower_ids - friend_ids
  end

  # we follow them, they don't reciprocate
  def asymmetric_friend_ids
    @asymmetric_friend_ids ||= friend_ids - follower_ids
  end

  def followers
    @followers ||= client.followers(user)
  end

  def friends
    @following ||= client.friends(user)
  end

  private
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
      client.access_token        = config[:twitter_access_token]
      client.access_token_secret = config[:twitter_access_secret]
    end
  end

  def user
    @user ||= client.user(username)
  end
end
