error ::Exception do
  response.status = 500
  content_type 'text/html'
  '<h1>SOPA RONPAUL BLACKOUT@)!@</h1>'
end

configure do
  set :method_override, false # For HTTP verbs
  set :sessions, false
  set :logging, false # stops annoying double log messages.
  set :static, false # see config.ru for dev mode static file serving
  set :feed_cache, 120
  set :reddit_feed, 'http://www.reddit.com/user/spidermonk/comments.rss?limit=20'
  set :lastfm_feed, 'http://ws.audioscrobbler.com/1.0/user/robomc/recenttracks.rss?limit=50'
  set :twitter_feed, 'http://twitter.com/statuses/user_timeline/20491432.rss?limit=30'
  set :github_feed, 'https://github.com/robomc.atom?limit=30' 
  set :background, 'http://i52.tinypic.com/2mdsccn.jpg'
#  set :redis, 1 # redis database
end

configure :development do
  set :raise_errors, true
  set :show_exceptions, true
  set :haml, {:format => :html5, :ugly => false, :escape_html => true}
end

configure :production do
  set :raise_errors, false
  set :show_exceptions, false
  set :haml, {:format => :html5, :ugly => true, :escape_html => true}
end

