error ::Exception do
  response.status = 500
  content_type 'text/html'
  '<h1>SOPA RONPAUL BLACKOUT@)!@</h1>'
end

configure do
  set :method_override, true # For HTTP verbs
  set :sessions, true
  set :logging, false # stops annoying double log messages.
  set :static, false # see config.ru for dev mode static file serving
  set :feed_cache, 120
  set :reddit_feed, 'http://www.reddit.com/user/spidermonk/comments.rss'
  set :lastfm_feed, 'http://ws.audioscrobbler.com/1.0/user/robomc/recenttracks.rss'
  set :twitter_feed, 'http://twitter.com/statuses/user_timeline/20491432.rss'
  set :github_feed, 'https://github.com/robomc.atom' 
  set :background, 'http://farm8.staticflickr.com/7179/6836626798_3db7a2c9be_o.jpg'
#  set :redis, 1 # redis database
end

configure :development do
  set :db, 'sqlite3://' + settings.root + '/db/development.sqlite3'
  set :raise_errors, true
  set :show_exceptions, true
  set :haml, {:format => :html5, :ugly => false, :escape_html => true}
end

configure :production do
  set :db, 'sqlite3://' + settings.root + '/db/production.sqlite3'
  set :raise_errors, false
  set :show_exceptions, false
  set :haml, {:format => :html5, :ugly => true, :escape_html => true}
end

# Database
# http://datamapper.rubyforge.org/dm-core/DataMapper.html

DataMapper.setup(:default, settings.db)

DataMapper::Property::String.length(255)
DataMapper::Property.required(true)
DataMapper::Logger.new($stdout, :info) if settings.development?

# Redis
# http://redis.io/commands
#$redis = Redis.new
#$redis.select settings.redis
