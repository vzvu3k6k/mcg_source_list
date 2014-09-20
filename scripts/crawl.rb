require 'twitter'
require 'open-uri'
require 'nokogiri'
require_relative '../lib/source'

Mongoid.load!(File.expand_path("../config/mongoid.yml", __dir__))

def get_source_info(id)
  doc = Nokogiri::HTML.parse(open("http://mcg.herokuapp.com/#{id}/").read)
  a = doc.at(".container a")
  { title: a.text }
end

def client
  @client ||= Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
    config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
    config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
    config.access_token_secret = ENV["TWITTER_ACCESS_TOKEN_SECRET"]
  end
end

def misc
  @misc ||= Mongoid.default_session.with(database: "misc")
end

def get_tweets
  last_tweet = misc[:tweets].find.sort(id: -1).one
  founds = client.search(
    "mcg.herokuapp.com/",
    result_type: :recent,
    trim_user: true,
    since_id: last_tweet ? last_tweet[:id_str] : 0,
  )

  # 後で使いたくなるかもしれないのでtweet自体も保存
  count = 0
  founds.each do |tweet|
    misc[:tweets].insert(tweet.to_h) # Mongoidを使わずにMopedを経由
    count += 1
  end
  puts "Saved #{count} tweets"

  founds
end

def save_sources(tweets)
  tweets.each do |tweet|
    tweet.urls.each do |url|
      url = url.expanded_url
      if url.host == "mcg.herokuapp.com" &&
          url.path.match(%r|/(\w+)/(?:(\w+)/)?|)
        Regexp.last_match.captures.compact.each do |id|
          source = Source.where(id_str: id).first
          unless source
            begin
              info = get_source_info(id)
              Source.create!(info.merge(
                last_used_at: tweet.created_at,
                id_str: id,
              ))
              warn "Saved #{id}"
            rescue
              p $!
            ensure
              sleep 3
            end
          else
            if source.last_used_at < tweet.created_at
              source.update_attribute(:last_used_at, tweet.created_at)
            end

            if source.created_at > tweet.created_at
              source.update_attribute(:created_at, tweet.created_at)
            end
          end
        end
      end
    end
  end
end

save_sources(get_tweets)
