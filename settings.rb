configure :development do
  set :db, 'sqlite3://' + settings.root + '/db/development.sqlite3'
	set :raise_errors, true
  set :show_exceptions, true
  set :static, false
  set :sessions, true
  set :highlighting, 'rack'
end

configure :production do
  set :db, 'sqlite3://' + settings.root + '/db/production.sqlite3'
	set :raise_errors, false
  set :show_exceptions, false
  set :static, false
  set :sessions, true
  set :highlighting, 'rack'
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
  :line_numbers => :inline,
  :bold_every => 10,
}

RedclothCoderay.coderay_options Haml::Filters::CodeRay.encoder_options

