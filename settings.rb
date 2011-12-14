configure do
  set :sessions, true
  set :highlighting, 'rack'
  set :logging, false # stop annoying double log messages...
  set :session_secret, "Ns7uwEYgHlvYp9-!.:R%*s{=#4}05J|'!*?YS[Ah7dn_SWa'.?(yMJ&.EzOskg"
  set :background, 'http://catlovers.todayblogpost.com/wp-content/uploads/2011/01/wpid-ScottishFoldHistory21.jpg'
  set :method_override, true
  set :reddit_feed, 'http://www.reddit.com/user/spidermonk/comments.rss'
  set :lastfm_feed, 'http://ws.audioscrobbler.com/1.0/user/robomc/recenttracks.rss'
  set :twitter_feed, 'http://twitter.com/statuses/user_timeline/20491432.rss'
  set :github_feed, 'https://github.com/robomc.atom'
end

configure :development do
  set :db, 'sqlite3://' + settings.root + '/db/development.sqlite3'
	set :raise_errors, true
  set :show_exceptions, true
  set :static, false
  set :background, 'http://catlovers.todayblogpost.com/wp-content/uploads/2011/01/wpid-ScottishFoldHistory21.jpg'
  set :method_override, true
  set :haml, {:format => :html5, :ugly => true }
  set :feed_cache, 20
end

configure :production do
  set :db, 'sqlite3://' + settings.root + '/db/production.sqlite3'
	set :raise_errors, false
  set :show_exceptions, false
  set :static, false
  set :sessions, true
  set :logging, false # stop annoying double log messages...
  set :haml, {:format => :html5, :ugly => true }
  set :feed_cache, 900
end

# Database
DataMapper::Logger.new($stdout, :info) if settings.development?

DataMapper.setup(:default, settings.db)

# Gems

Haml::Filters::CodeRay.encoder_options = {
  :css => :class,
  :wrap => :div,
}

RedclothCoderay.coderay_options Haml::Filters::CodeRay.encoder_options

#
# Monkey patch to clean up logs until other gems are updated for newer Sinatra versions
#

class Sinatra::Base
  def options
    settings
  end
end

