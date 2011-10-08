configure :development do
  set :db, 'sqlite3://' + settings.root + '/db/production.sqlite3'
	set :raise_errors, true
  set :show_exceptions, true
  set :static, false
  set :sessions, true
  set :highlighting, 'rack'
  set :logging, false # stop annoying double log messages...
  set :session_secret, "Ns7uwEYgHlvYp9-!.:R%*s{=#4}05J|'!*?YS[Ah7dn_SWa'.?(yMJ&.EzOskg"
  set :background, 'http://catlovers.todayblogpost.com/wp-content/uploads/2011/01/wpid-ScottishFoldHistory21.jpg'
end

configure :production do
  set :db, 'sqlite3://' + settings.root + '/db/production.sqlite3'
	set :raise_errors, false
  set :show_exceptions, false
  set :static, false
  set :sessions, true
  set :highlighting, 'zenburn'
  set :logging, false # stop annoying double log messages...
  set :session_secret, "Ns7uwEYgHlvYp9-!.:R%*s{=#4}05J|'!*?YS[Ah7dn_SWa'.?(yMJ&.EzOskg"
  set :background, 'http://catlovers.todayblogpost.com/wp-content/uploads/2011/01/wpid-ScottishFoldHistory21.jpg'
end

# Database
DataMapper::Logger.new($stdout, :info) if settings.development?

DataMapper.setup(:default, settings.db)

# Gems

HAML_OPTS = {
  :format => :html5,
  :ugly => true,
}

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

